# Joplin skill direct wiring

Replaced the custom `install-store-dir-script.nix` activation used for the Joplin CLI skill with Home Manager's direct file wiring:

```nix
home.file.".agents/skills/joplin-cli".source = ./skills/joplin-cli;
```

Removed the now-unused install-script import and `lib` module argument.

Validation commands could not run in the sandbox: Nix was denied access to `~/.cache/nix` and `~/.nix-defexpr/channels`.
