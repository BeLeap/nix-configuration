UNAME := $(shell uname -s)
.DEFAULT_GOAL := switch

NIXNAME ?= $(if $(filter Darwin,$(UNAME)),unset,vmware-arm64-Darwin-personal)
VM_NIXNAME ?= vmware-arm64-Darwin-personal
NIXADDR ?= unset
NIXPORT ?= 22
ERASE_VM_DISK ?= unset
NIXUSER ?= beleap
NIXDIR ?= /home/$(NIXUSER)/nix-configuration
NIX_SSHOPTS ?= -p $(NIXPORT)

.PHONY: switch test check vm/bootstrap0 vm/copy vm/switch vm/test

ifeq ($(UNAME),Darwin)
switch test:
	@test -n "$(NIXNAME)" && [ "$(NIXNAME)" != unset ] || { echo 'Set NIXNAME to a Darwin host.' >&2; exit 2; }
	nix build ".#darwinConfigurations.$(NIXNAME).system"
	sudo ./result/sw/bin/darwin-rebuild $@ --flake "$(CURDIR)#$(NIXNAME)"
else
switch test:
	sudo nixos-rebuild $@ --accept-flake-config --flake ".#$(NIXNAME)"
endif

check:
	nix flake check --all-systems --no-build
	nix eval --raw '.#nixosConfigurations.$(VM_NIXNAME).config.system.build.toplevel.drvPath' >/dev/null

vm/bootstrap0:
	@test -n "$(NIXADDR)" && [ "$(NIXADDR)" != unset ] || { echo 'Set NIXADDR to the NixOS installer IP.' >&2; exit 2; }
	@test "$(ERASE_VM_DISK)" = "/dev/nvme0n1" || { echo 'Set ERASE_VM_DISK=/dev/nvme0n1 to confirm the VM disk.' >&2; exit 2; }
	scp -P "$(NIXPORT)" bin/vm-bootstrap0 "root@$(NIXADDR):/tmp/vm-bootstrap0"
	ssh -tt -p "$(NIXPORT)" "root@$(NIXADDR)" "bash /tmp/vm-bootstrap0"

vm/copy:
	@test -n "$(NIXADDR)" && [ "$(NIXADDR)" != unset ] || { echo 'Set NIXADDR to the VMware guest IP.' >&2; exit 2; }
	ssh -p "$(NIXPORT)" "$(NIXUSER)@$(NIXADDR)" "mkdir -p '$(NIXDIR)'"
	rsync -av -e "ssh -p $(NIXPORT)" --exclude='.git/' --exclude='.jj/' --exclude='.journal/' --exclude='.direnv/' --exclude='result' --exclude='nixos.qcow2' ./ "$(NIXUSER)@$(NIXADDR):$(NIXDIR)/"

vm/switch vm/test:
	@test -n "$(NIXADDR)" && [ "$(NIXADDR)" != unset ] || { echo 'Set NIXADDR to the VMware guest IP.' >&2; exit 2; }
	NIX_SSHOPTS="$(NIX_SSHOPTS)" nix run nixpkgs#nixos-rebuild-ng -- $(patsubst vm/%,%,$@) --flake "$(CURDIR)#$(VM_NIXNAME)" --build-host "$(NIXUSER)@$(NIXADDR)" --target-host "$(NIXUSER)@$(NIXADDR)" --sudo --no-reexec --accept-flake-config --max-jobs 1 --cores 1
