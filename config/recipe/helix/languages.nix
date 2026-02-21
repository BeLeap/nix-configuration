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
    file-types = [
      "kt"
      "kts"
    ];
    roots = [
      "build.gradle"
      "build.gradle.kts"
      "settings.gradle"
      "settings.gradle.kts"
      "pom.xml"
    ];
    auto-format = true;
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
]
++
# Javascript family
map
(name: {
  name = name;
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
