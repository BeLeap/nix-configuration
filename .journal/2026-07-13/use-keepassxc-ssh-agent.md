# Use KeePassXC for SSH integration

- Kept the 1Password CLI and desktop applications installed on personal hosts.
- Removed only the forced 1Password `IdentityAgent` SSH setting.
- Personal hosts already include KeePassXC with SSH Agent integration enabled, so KeePassXC connects to the platform OpenSSH agent through its inherited agent socket.
