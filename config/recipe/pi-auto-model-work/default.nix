_: {
  home = [
    (_: {
      home.file.".pi/agent/auto-model.json".text = builtins.toJSON {
        enabled = true;
        constraints.providerAllow = ["openai"];
      };
    })
  ];
}
