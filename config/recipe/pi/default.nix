_: {
  hm = [
    ({pkgs, ...}: {
      home = {
        packages = [pkgs.llm-agents.pi];

        shellAliases = {
          p = "pi";
        };
      };
    })
  ];
}
