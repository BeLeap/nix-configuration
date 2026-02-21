_: {
  hm = [
    (
      _: {
        home.shellAliases = {
          prcm = "gh pr create --assignee @me";
          prv = "gh pr view";
          prvw = "gh pr view -w";
          prm = "gh pr merge";
          prmd = "gh pr merge -d";
        };
        programs.gh = {
          enable = true;
        };
      }
    )
  ];
}
