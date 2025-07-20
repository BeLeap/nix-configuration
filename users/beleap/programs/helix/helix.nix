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
      language-server.biome = {
        command = "biome";
        args = ["lsp-proxy"];
        required-root-patterns = ["biome.json"];
      };
      language-server.kotlin-ls = {
        command = "kotlin-ls";
        args = ["--stdio"];
        timeout = 60;
        required-root-pattern = ["build.gradle" "build.gradle.kts" "pom.xml"];
      };
      language-server.typescript-language-server = with pkgs.nodePackages; {
        command = "${typescript-language-server}/bin/typescript-language-server";
        args = [ "--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib" ];
      };

      language = import ./languages.nix;
    };
  };
}
