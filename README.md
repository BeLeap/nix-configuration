# nix-configuration

## macOS

### Configuartion

#### Initialize

```sh
sudo nix --extra-experimental-features "nix-command flakes" run "nix-darwin/master#darwin-rebuild" -- switch --flake ".#beleap-m1air"
```

#### Switch

```sh
sudo darwin-rebuild switch --flake ".#beleap-m1air"
```

### Home

#### Switch

```sh
home-manager switch
```

#### Build

```sh
home-manager build
```
