{
  agenix,
  metadata,
  ...
}: {
  hm = [
    (
      {
        config,
        pkgs,
        ...
      }: let
        pi = pkgs.symlinkJoin {
          name = "pi";
          paths = [pkgs.llm-agents.pi];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/pi \
              --run 'export CONTEXT7_API_KEY="$(${pkgs.coreutils}/bin/cat ${config.age.secrets."context7-api-key".path})"'
          '';
        };
      in {
        imports = [(import ../../../lib/agenix/hm.nix {inherit agenix metadata;})];

        age.secrets = {
          context7-api-key.file = ../opencode/secrets/context7-api-key.age;
        };

        home = {
          packages = [
            pi
          ];

          file = {
            ".pi/agent/AGENTS.md".source = ../../../files/AGENTS.md;
            ".pi/agent/settings.json".text = builtins.toJSON {
              packages = [
                "npm:@upstash/context7-pi@0.1.1"
              ];
            };
          };
        };
      }
    )
  ];
}
