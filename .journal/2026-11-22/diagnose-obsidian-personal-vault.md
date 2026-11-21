# Diagnose missing Obsidian personal vault

- `config/recipe/beleap-m1air/default.nix` enables `programs.obsidian.vaults.personal` without setting `target`.
- The effective Home Manager option resolves `target` to `personal`, so the generated Obsidian registry path is `/Users/beleap/personal`.
- The Obsidian module creates vault settings files only when a settings value is non-null. This vault has only null settings, so Home Manager creates no files under the target and does not create the directory.
- The generated activation template contains `/Users/beleap/personal`. The current `obsidian.json` instead lists `/Users/beleap/Documents/Obsidian Vault`, and `/Users/beleap/personal` does not exist. The current Nix setting is not active in the on-disk Obsidian registry.
- The activation script merges the generated template at the top-level JSON object. Its `vaults` value replaces the existing `vaults` map. Applying the current configuration would replace the existing vault registration with `/Users/beleap/personal`.
- To manage the existing vault, set `programs.obsidian.vaults.personal.target = "Documents/Obsidian Vault"` before applying the Darwin configuration. No configuration or activation changes were made during this diagnosis.
- Validation: Home Manager option evaluation returned `target = "personal"`; the generated JSON template contained `/Users/beleap/personal`; the current app JSON and filesystem paths were checked. No Darwin switch ran.
