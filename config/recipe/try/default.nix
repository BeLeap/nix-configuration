{try}: {
  hm = [
    try.homeModules.default
    {
      programs.try.enable = true;
    }
  ];
}
