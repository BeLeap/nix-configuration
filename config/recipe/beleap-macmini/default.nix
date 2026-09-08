{inputs, ...}: {
  darwin = {
    system = [
      (_: {
        homebrew = {
          brews = [
            "googleworkspace-cli"
            "ollama"
          ];
        };
      })
      (_: {
        services.github-runners."beleap-macmini" = {
          enable = true;
          url = "https://github.com/BeLeap/nix-configuration";
          tokenFile = "/run/secrets/github-runner.token";
          extraLabels = ["beleap-macmini"];
          ephemeral = false;
        };
      })
    ];
    home = [
      ({
        config,
        lib,
        pkgs,
        ...
      }: let
        ollamaModel = "qwen3.5:4b";
        discordUserId = "540435382853173280";
        zeroclawBin = "${lib.getExe inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.zeroclaw}";
        stateDir = "${config.home.homeDirectory}/.zeroclaw";
        configFile = "${stateDir}/config.toml";
        discordTokenFile = "${stateDir}/discord-bot-token";
        piDelegateAgentWorkspace = "${stateDir}/agents/default/workspace";
        piDelegateStateDir = "${piDelegateAgentWorkspace}/.pi-delegate";
        piDelegateWorkspace = "${config.home.homeDirectory}/ws";
        piDelegateRunner = pkgs.writeShellScriptBin "zeroclaw-pi-delegate" (
          lib.replaceStrings
          ["@stateDir@" "@homeDir@" "@projectRoot@" "@piBin@" "@coreutils@"]
          [
            piDelegateStateDir
            config.home.homeDirectory
            piDelegateWorkspace
            "${config.home.profileDirectory}/bin/pi"
            "${pkgs.coreutils}"
          ]
          (builtins.readFile ./pi-delegate-runner.sh)
        );
        piDelegateSkill = pkgs.writeText "zeroclaw-pi-delegate-SKILL.toml" (
          lib.replaceStrings
          ["@runner@" "@projectRoot@"]
          ["${piDelegateRunner}/bin/zeroclaw-pi-delegate" piDelegateWorkspace]
          (builtins.readFile ./pi-delegate-skill.toml)
        );
        zeroclawConfigSource = pkgs.writeText "zeroclaw-config.toml" ''
          schema_version = 3

          [providers]

          [providers.models.custom.default]
          uri = "http://127.0.0.1:11434/v1"
          max_tokens = 4096
          temperature = 0.2
          timeout_secs = 300
          wire_api = "chat_completions"
          model = "${ollamaModel}"
          native_tools = true
          replay_assistant_reasoning = false
          think = false
          context_window = 32768

          [channels.discord.default]
          enabled = true
          bot_token = "$ZEROCLAW_DISCORD_BOT_TOKEN"
          mention_only = false
          listen_to_bots = false

          [agents.default]
          model_provider = "custom.default"
          risk_profile = "default"
          runtime_profile = "default"
          channels = ["discord.default"]

          [peer_groups.discord_default]
          channel = "discord"
          agents = ["default"]
          external_peers = ["${discordUserId}"]

          [risk_profiles.default]
          level = "supervised"
          workspace_only = true
          require_approval_for_medium_risk = true
          block_high_risk_commands = true
          allowed_commands = ["git", "npm", "cargo", "ls", "cat", "grep", "find", "echo", "pwd", "wc", "head", "tail", "date", "df", "du", "uname", "uptime", "hostname", "python", "python3", "pip", "node", "zeroclaw-pi-delegate"]
          auto_approve = ["file_read", "memory_recall", "web_search_tool", "web_fetch", "calculator", "glob_search", "content_search", "image_info", "weather", "browser", "browser_open", "read_skill", "pi_delegate__status"]
          always_ask = ["pi_delegate__start", "pi_delegate__cancel"]
          allowed_roots = []
          forbidden_paths = ["/etc", "/root", "/home", "/usr", "/bin", "/sbin", "/lib", "/opt", "/boot", "/dev", "/proc", "/sys", "/var", "/tmp", "~/.ssh", "~/.gnupg", "~/.aws", "~/.config"]
          max_actions_per_hour = 20
          max_cost_per_day_cents = 500
          excluded_tools = []
          shell_env_passthrough = []
          shell_timeout_secs = 60

          [runtime_profiles.default]
          compact_context = true
          max_tool_iterations = 16
          max_context_tokens = 32768
          max_actions_per_hour = 20
          max_cost_per_day_cents = 500
          shell_timeout_secs = 60

          [skills]
          prompt_injection_mode = "compact"

          [channels]
          cli = true
          message_timeout_secs = 600
          ack_reactions = true
          show_tool_calls = false
          session_persistence = true
          session_backend = "sqlite"

          [memory]
          backend = "sqlite"
          auto_save = true
          embedding_provider = "none"
          search_mode = "bm25"

          [runtime]
          kind = "native"
          reasoning_enabled = false

          [gateway]
          host = "127.0.0.1"
          port = 42617
          require_pairing = true
          allow_public_bind = false
        '';
        zeroclawDaemon = pkgs.writeShellScript "zeroclaw-daemon" ''
          set -eu
          umask 077

          state_dir=${lib.escapeShellArg stateDir}
          config_file=${lib.escapeShellArg configFile}
          token_file=${lib.escapeShellArg discordTokenFile}
          project_root=${lib.escapeShellArg piDelegateWorkspace}
          agent_workspace=${lib.escapeShellArg piDelegateAgentWorkspace}
          delegate_state_dir=${lib.escapeShellArg piDelegateStateDir}
          config_source=${lib.escapeShellArg zeroclawConfigSource}

          /bin/mkdir -p "$project_root" "$agent_workspace/skills/pi_delegate" "$delegate_state_dir"
          skill_file="$agent_workspace/skills/pi_delegate/SKILL.toml"
          if [ -L "$skill_file" ]; then
            echo "Refusing to replace symlinked ZeroClaw skill: $skill_file" >&2
            exit 1
          fi
          /bin/cp -f ${piDelegateSkill} "$skill_file"
          /bin/chmod 600 "$skill_file"

          if [ ! -s "$token_file" ]; then
            echo "Waiting for Discord bot token at $token_file" >&2
          fi
          while [ ! -s "$token_file" ]; do
            /bin/sleep 5
          done

          discord_token="$(/bin/cat "$token_file")"
          if [ -z "$discord_token" ]; then
            echo "Discord bot token file is empty" >&2
            exit 1
          fi
          export ZEROCLAW_DISCORD_BOT_TOKEN="$discord_token"

          # Render the external token into a private runtime config instead of the Nix store.
          tmp_config="$config_file.tmp.$$"
          ${pkgs.gettext}/bin/envsubst '$ZEROCLAW_DISCORD_BOT_TOKEN' < "$config_source" > "$tmp_config"
          /bin/chmod 600 "$tmp_config"
          /bin/mv -f "$tmp_config" "$config_file"
          unset ZEROCLAW_DISCORD_BOT_TOKEN

          exec ${zeroclawBin} daemon
        '';
      in {
        home.packages = with pkgs; [
          isync
          unstable.zeroclaw
          piDelegateRunner
        ];
        launchd.agents.zeroclaw = {
          enable = true;
          config = {
            Program = zeroclawDaemon;
            ProgramArguments = ["${zeroclawDaemon}"];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/zeroclaw.out.log";
            StandardErrorPath = "/tmp/zeroclaw.err.log";
          };
        };
        launchd.agents.ollama = {
          enable = true;
          config = {
            Program = "/opt/homebrew/bin/ollama";
            ProgramArguments = ["serve"];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama.out.log";
            StandardErrorPath = "/tmp/ollama.err.log";
            EnvironmentVariables = {
              OLLAMA_HOST = "0.0.0.0:11434";
              OLLAMA_CONTEXT_LENGTH = "32768";
              OLLAMA_NUM_PARALLEL = "1";
              OLLAMA_MAX_LOADED_MODELS = "1";
              OLLAMA_NO_CLOUD = "1";
            };
          };
        };
      })
    ];
  };
}
