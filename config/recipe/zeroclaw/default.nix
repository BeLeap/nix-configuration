{inputs, ...}: {
  darwin.home = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        cfg = config.beleap.services.zeroclaw;
        zeroclawPackage = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.zeroclaw;
        agentBrowser = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser;
        agentBrowserSkill = "${agentBrowser}/share/agent-browser/skills/agent-browser/SKILL.md";
        zeroclawCliPackage = pkgs.unstable.zeroclaw;
        inherit (cfg) stateDirectory;
        configFile = "${stateDirectory}/config.toml";
        piDelegateAgentWorkspace = "${stateDirectory}/agents/default/workspace";
        piDelegateStateDirectory = "${piDelegateAgentWorkspace}/.pi-delegate";
        piDelegateRunner = pkgs.writeShellScriptBin "zeroclaw-pi-delegate" (
          lib.replaceStrings
          ["@stateDir@" "@homeDir@" "@projectRoot@" "@piBin@" "@coreutilsBin@"]
          [
            (lib.escapeShellArg piDelegateStateDirectory)
            (lib.escapeShellArg config.home.homeDirectory)
            (lib.escapeShellArg cfg.projectRoot)
            (lib.escapeShellArg "${config.home.profileDirectory}/bin/pi")
            (lib.escapeShellArg "${pkgs.coreutils}/bin")
          ]
          (builtins.readFile ./pi-delegate-runner.sh)
        );
        piDelegateSkill = pkgs.writeText "zeroclaw-pi-delegate-SKILL.toml" (
          lib.replaceStrings
          ["@runner@" "@projectRoot@"]
          ["${piDelegateRunner}/bin/zeroclaw-pi-delegate" cfg.projectRoot]
          (builtins.readFile ./pi-delegate-skill.toml)
        );
        zeroclawConfigSource = pkgs.writeText "zeroclaw-config.toml" (
          lib.replaceStrings
          ["@providerUrl@" "@model@" "@discordUserId@" "@gatewayHost@" "@gatewayPort@" "@gatewayAllowPublicBind@"]
          [
            (builtins.toJSON cfg.providerUrl)
            (builtins.toJSON cfg.model)
            (builtins.toJSON cfg.discordUserId)
            (builtins.toJSON cfg.gatewayHost)
            (toString cfg.gatewayPort)
            (
              if cfg.gatewayAllowPublicBind
              then "true"
              else "false"
            )
          ]
          (builtins.readFile ./zeroclaw-config.toml)
        );
        zeroclawDaemon = pkgs.writeShellScript "zeroclaw-daemon" (
          lib.replaceStrings
          [
            "@coreutilsBin@"
            "@configFile@"
            "@configSource@"
            "@discordTokenFile@"
            "@envsubst@"
            "@piDelegateSkill@"
            "@agentBrowserSkill@"
            "@projectRoot@"
            "@agentWorkspace@"
            "@delegateStateDir@"
            "@zeroclawBin@"
          ]
          [
            (lib.escapeShellArg "${pkgs.coreutils}/bin")
            (lib.escapeShellArg configFile)
            (lib.escapeShellArg zeroclawConfigSource)
            (lib.escapeShellArg cfg.discordTokenFile)
            (lib.escapeShellArg "${pkgs.gettext}/bin/envsubst")
            (lib.escapeShellArg piDelegateSkill)
            (lib.escapeShellArg agentBrowserSkill)
            (lib.escapeShellArg cfg.projectRoot)
            (lib.escapeShellArg piDelegateAgentWorkspace)
            (lib.escapeShellArg piDelegateStateDirectory)
            (lib.escapeShellArg (lib.getExe zeroclawPackage))
          ]
          (builtins.readFile ./zeroclaw-daemon.sh)
        );
      in {
        options.beleap.services.zeroclaw = {
          enable = lib.mkEnableOption "the ZeroClaw Discord agent";

          model = lib.mkOption {
            type = lib.types.str;
            default = "qwen3.5:4b";
            description = "Model served to ZeroClaw by the configured provider.";
          };

          providerUrl = lib.mkOption {
            type = lib.types.str;
            default = "http://127.0.0.1:11434/v1";
            description = "OpenAI-compatible provider URL used by ZeroClaw.";
          };

          discordUserId = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Discord user ID authorized to use the agent.";
          };

          stateDirectory = lib.mkOption {
            type = lib.types.str;
            default = "${config.home.homeDirectory}/.zeroclaw";
            description = "Private directory containing ZeroClaw state and runtime configuration.";
          };

          discordTokenFile = lib.mkOption {
            type = lib.types.str;
            default = "${config.home.homeDirectory}/.zeroclaw/discord-bot-token";
            description = "File containing the Discord bot token.";
          };

          projectRoot = lib.mkOption {
            type = lib.types.str;
            default = "${config.home.homeDirectory}/ws";
            description = "Managed working directory for delegated Pi tasks.";
          };

          gatewayHost = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "ZeroClaw gateway bind address.";
          };

          gatewayPort = lib.mkOption {
            type = lib.types.ints.between 1 65535;
            default = 42617;
            description = "ZeroClaw gateway bind port.";
          };

          gatewayAllowPublicBind = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether ZeroClaw may bind its gateway publicly.";
          };
        };

        config = lib.mkIf cfg.enable {
          assertions = [
            {
              assertion = cfg.discordUserId != "";
              message = "beleap.services.zeroclaw.discordUserId must not be empty when ZeroClaw is enabled.";
            }
            {
              assertion = cfg.discordTokenFile != "";
              message = "beleap.services.zeroclaw.discordTokenFile must not be empty when ZeroClaw is enabled.";
            }
            {
              assertion = lib.hasPrefix "/" cfg.stateDirectory;
              message = "beleap.services.zeroclaw.stateDirectory must be an absolute path.";
            }
            {
              assertion = lib.hasPrefix "/" cfg.discordTokenFile;
              message = "beleap.services.zeroclaw.discordTokenFile must be an absolute path.";
            }
            {
              assertion = lib.hasPrefix "/" cfg.projectRoot;
              message = "beleap.services.zeroclaw.projectRoot must be an absolute path.";
            }
            {
              assertion = cfg.gatewayAllowPublicBind || cfg.gatewayHost == "127.0.0.1";
              message = "beleap.services.zeroclaw.gatewayHost must remain 127.0.0.1 unless gatewayAllowPublicBind is enabled.";
            }
          ];

          home.packages = [zeroclawCliPackage piDelegateRunner];

          launchd.agents.zeroclaw = {
            enable = true;
            config = {
              Program = zeroclawDaemon;
              ProgramArguments = ["${zeroclawDaemon}"];
              KeepAlive = true;
              RunAtLoad = true;
              StandardOutPath = "/tmp/zeroclaw.out.log";
              StandardErrorPath = "/tmp/zeroclaw.err.log";
              EnvironmentVariables = {
                PATH = "${config.home.profileDirectory}/bin:${config.home.homeDirectory}/.npm-global/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin";
              };
            };
          };
        };
      }
    )
  ];
}
