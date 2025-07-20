{ pkgs, ... }: {
  programs.helix = {
    enable = true;

    defaultEditor = true;

    settings = {
      theme = "catppuccin_frappe";

      editor = {
        line-number = "relative";
        end-of-line-diagnostics = "hint";

        inline-diagnostics = {
          cursor-line = "error";
        };

        file-picker = {
          hidden = false;
          git-ignore = false;
          git-global = false;
          git-exclude = false;
        };

        soft-wrap = {
          enable = true;
        };

        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name" "read-only-indicator" "file-modification-indicator"];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
        };

        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };

        whitespace.render.tab = "all";
        indent-guides.render = true;
      };
    };

    languages = {
      language-server = import ./language-servers.nix { inherit pkgs; };
      language = import ./languages.nix;
    };
  };
}
