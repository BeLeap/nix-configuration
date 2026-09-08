{inputs, ...}: {
  home = [
    ({pkgs, ...}: let
      agentBrowser = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser;
    in {
      home = {
        packages = [agentBrowser];
        file.".agents/skills/agent-browser".source = "${agentBrowser}/share/agent-browser/skills/agent-browser";
      };
    })
  ];
}
