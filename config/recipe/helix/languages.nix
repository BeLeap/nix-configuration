{
  pkgs,
  lib,
  ...
}:
[
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
    name = "markdown";
    file-types = [
      "md"
      "markdown"
      "mdown"
      "mkdn"
      "mkd"
      "mdwn"
      "mdtxt"
      "mdtext"
      "mdx"
    ];
  }
  {
    name = "jjdescription";
    comment-token = "JJ:";
    file-types = [{glob = "*.jjdescription";}];
  }
  {
    name = "dockerfile";
    scope = "source.dockerfile";
    file-types = [
      "Dockerfile"
      {glob = "*Dockerfile*";}
    ];
  }
  {
    name = "bash";
    indent = {
      tab-width = 4;
      unit = "    ";
    };
    formatter = {
      command = "${lib.getExe pkgs.shfmt}";
      args = [
        "-i"
        "4"
      ];
    };
    auto-format = true;
  }
  {
    name = "kotlin";
    scope = "source.kotlin";
    injection-regex = "kotlin";
    auto-format = false;
    language-servers = ["kotlin-lsp"];
  }
  {
    name = "java";
    auto-format = false;
    language-servers = ["kotlin-lsp"];
  }
  {
    name = "nix";
    language-servers = ["nil"];
    formatter = {
      command = "${lib.getExe pkgs.alejandra}";
    };
    auto-format = true;
  }
  {
    name = "helm";
    roots = ["Chart.yaml"];
    language-servers = ["helm-ls"];
  }
]
++
# Javascript family
map
(name: {
  inherit name;
  auto-format = true;
  language-servers = [
    {
      name = "typescript-language-server";
      except-features = ["format"];
    }
    "biome"
  ];
})
[
  "javascript"
  "typescript"
  "jsx"
  "tsx"
  "json"
]
