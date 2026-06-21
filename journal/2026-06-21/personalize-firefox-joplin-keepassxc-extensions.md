# Personalize Firefox Joplin and KeePassXC Extensions

- Moved `joplin-web-clipper` and `keepassxc-browser` out of the shared Firefox recipe.
- Added those Firefox extensions through the `personal` recipe so they follow hosts that install Joplin and KeePassXC.
- Kept shared Firefox extensions (`sidebery`, `wappalyzer`, `consent-o-matic`) in `config/recipe/firefox/default.nix`.
