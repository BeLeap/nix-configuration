# Keep Discord off the personal ARM Linux VM

- Removed the `discord` recipe from shared `personal` and included it directly on the two personal Darwin hosts. The personal NixOS VM no longer evaluates the unsupported `discord` package (`aarch64-linux`); both Macs retain their existing Discord recipe.
- Validation: Alejandra check passed; evaluation of `vm-arm64-Darwin-personal.config.system.build.vm.drvPath`, its NixOS toplevel, and `beleap-m1air.system.drvPath` passed.
