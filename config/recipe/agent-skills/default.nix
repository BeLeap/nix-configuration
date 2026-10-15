{inputs, ...}: {
  home = [
    ({pkgs, ...}: {
      home = {
        packages = [
          inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
        ];
        file = {
          ".agents/skills/hypothesis-driven-inquiry".source = ./skills/hypothesis-driven-inquiry;
          ".agents/skills/agent-browser".source = ./skills/agent-browser;
        };
      };
    })
  ];
}
