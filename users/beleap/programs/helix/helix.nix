_: {
  programs.helix = {
    enable = true;

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

      language = [
        {
          name = "rust";
          auto-format = true;
          language-servers = ["rust-analyzer"];
        }
        {
          name = "python";
          language-servers = ["pyright"];
        }
        {
          name = "dockerfile";
          scope = "source.dockerfile";
          file-types = ["Dockerfile" { glob = "*Dockerfile*"; }];
        }
        {
          name = "bash";
          indent.tab-width = 4;
          indent.unit = "    ";
          formatter.command = "shfmt";
          formatter.args = ["-i" "4"];
          auto-format = true;
        }
        {
          name = "kotlin";
          scope = "source.kotlin";
          injection-regex = "kotlin";
          file-types = ["kt" "kts"];
          roots = ["build.gradle" "build.gradle.kts" "settings.gradle" "settings.gradle.kts" "pom.xml"];
          auto-format = true;
          language-servers = ["kotlin-ls"];
        }
      ]
      ++
      # Javascript family
      map (name: {
        name = name;
        auto-format = true;
        language-servers = [
          { name = "typescrpit-language-server"; except-featuers = ["format"]; }
          "biome"
        ];
      }) ["javascript" "typescript" "jsx" "tsx" "json"];

      grammar = [
        {
          name = "dockerfile";
          source = { git = "https://github.com/camdencheek/tree-sitter-dockerfile"; rev = "main"; };
        }
      ];
    };
  };
}
