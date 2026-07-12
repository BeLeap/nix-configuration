_: {
  hm = [
    (
      {pkgs, ...}: {
        home = {
          packages = [
            pkgs.llm-agents.pi
          ];

          file.".pi/agent/AGENTS.md".source = ../../../files/AGENTS.md;
        };
      }
    )
  ];
}
