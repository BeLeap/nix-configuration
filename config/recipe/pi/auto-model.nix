{enabled ? false}: {
  home = [
    (_: {
      home.file.".pi/agent/auto-model.json".text = builtins.toJSON {
        inherit enabled;
      };
    })
  ];
}
