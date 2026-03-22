{
  agenix,
  metadata,
  nix-openclaw,
  nix-steipete-tools,
}: {
  base = _: {
    homebrew = {
      brews = ["ollama"];
    };
  };

  hm = [
    nix-openclaw.homeManagerModules.openclaw
    ({
      config,
      pkgs,
      ...
    }: {
      imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

      age.secrets = {
        discord-token.file = ./secrets/discord-token.age;
      };

      programs.openclaw = {
        documents = ./documents;

        config = {
          gateway = {
            mode = "local";
          };
          channels.discord = {
            token = {
              source = "file";
              provider = config.age.secrets."discord-token".path;
            };
          };
        };

        instances.default = {
          enable = true;
          package = pkgs.openclaw;
          stateDir = "~/.openclaw";
          workspaceDir = "~/.openclaw/workspace";
          launchd.enable = true;

          plugins = [
            nix-steipete-tools.packages.aarch64-darwin.peekaboo
          ];
        };
      };
    })
    (_: {
      launchd.agents = {
        ollama = {
          enable = true;
          config = {
            Program = "/opt/homebrew/bin/ollama";
            ProgramArguments = ["serve"];
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama.log";
            StandardErrorPath = "/tmp/ollama.log";
          };
        };
      };
    })
  ];
}
