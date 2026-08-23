_: {
  systemModules = [
    (_: {
      homebrew = {
        brews = [
          "googleworkspace-cli"
          "ollama"
        ];
      };
    })
  ];

  homeModules = [
    ({
      config,
      lib,
      pkgs,
      ...
    }: let
      ollamaModel = "qwen3.5:4b";
      zeroclawBin = "${pkgs.zeroclaw}/bin/zeroclaw";
      stateDir = "${config.home.homeDirectory}/.zeroclaw";
      configFile = "${stateDir}/config.toml";
      discordTokenFile = "${stateDir}/discord-bot-token";
      zeroclawConfigSource = pkgs.writeText "zeroclaw-config.toml" ''
        schema_version = 2

        [providers]
        fallback = "ollama"

        [providers.models.ollama]
        base_url = "http://127.0.0.1:11434"
        max_tokens = 4096
        temperature = 0.2
        timeout_secs = 300
        wire_api = "chat_completions"
        model = "${ollamaModel}"

        [autonomy]
        level = "supervised"
        workspace_only = true
        require_approval_for_medium_risk = true
        block_high_risk_commands = true

        [agent]
        compact_context = true
        max_tool_iterations = 8
        max_context_tokens = 8192

        [channels]
        cli = true
        message_timeout_secs = 300
        ack_reactions = true
        show_tool_calls = false
        session_persistence = true
        session_backend = "sqlite"

        [channels.discord]
        enabled = true
        bot_token = "$ZEROCLAW_DISCORD_BOT_TOKEN"
        allowed_users = ["*"]
        mention_only = true
        listen_to_bots = false

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
        config_source=${lib.escapeShellArg zeroclawConfigSource}

        /bin/mkdir -p "$state_dir"
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

        # ZeroClaw 0.7.5 has no nested environment override for channel secrets.
        # Render the external token into a private runtime config instead.
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
        zeroclaw
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
}
