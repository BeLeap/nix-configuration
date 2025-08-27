pkgs:
pkgs.writeTextFile {
  name = "wezterm";
  destination = "/etc/profile.d/wezterm.sh";

  text = builtins.readFile ./wezterm.sh;
}
