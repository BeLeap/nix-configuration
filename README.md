# nix-configuration

## macOS

### Initialize

```sh
sudo nix --extra-experimental-features "nix-command flakes" run "nix-darwin/master#darwin-rebuild" -- switch --flake ".#beleap-m1air"
```

### Switch

```sh
sudo darwin-rebuild switch --flake ".#beleap-m1air"
```
