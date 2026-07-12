# Migrate SSH matchBlocks

- Replaced deprecated Home Manager `programs.ssh.matchBlocks` usage with `programs.ssh.settings`.
- Updated the 1Password SSH agent config to use the OpenSSH directive name `IdentityAgent`.
- Kept the default `Host *` block in the SSH recipe while avoiding the deprecated alias warning.
