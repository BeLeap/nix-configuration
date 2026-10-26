let
  allowWrite = ["."];
  sensitiveReadPaths = [
    "~/.ssh"
    "~/.ssh/**"
    "~/.aws"
    "~/.aws/**"
    "~/.gnupg"
    "~/.gnupg/**"
    "~/.azure"
    "~/.azure/**"
    "~/.netrc"
    "~/.git-credentials"
    "~/.pypirc"
    "~/.gem/credentials"
    "~/.vault-token"
    "~/.password-store"
    "~/.password-store/**"
    "~/.pi/agent/auth.json"
    "~/.pi/agent/oauth.json"
    "~/.config/gh/hosts.yml"
    "~/.config/gcloud/application_default_credentials.json"
    "~/.config/gcloud/credentials.db"
    "~/.config/gcloud/access_tokens.db"
    "~/.kube/config"
    "~/.docker/config.json"
    ".env"
    ".env.*"
    "**/.env"
    "**/.env.*"
    ".envrc*"
    "**/.envrc*"
    ".direnv"
    ".direnv/**"
    "**/.direnv"
    "**/.direnv/**"
    ".npmrc"
    "**/.npmrc"
    ".yarnrc.yml"
    "**/.yarnrc.yml"
    ".pypirc"
    "**/.pypirc"
    "*.pem"
    "**/*.pem"
    "*.key"
    "**/*.key"
    "**/id_rsa"
    "**/id_ed25519"
    "**/id_ecdsa"
    "**/id_dsa"
  ];
  denyRead = sensitiveReadPaths;
  pathPermission =
    {"*" = "allow";}
    // builtins.listToAttrs (map (path: {
        name = path;
        value = "deny";
      })
      sensitiveReadPaths);
  externalDirectoryPermission = "allow";
  askToolPermission = {
    "*" = "ask";
    "resolve-library-id" = "allow";
    "query-docs" = "allow";
  };
  askSkillPermission = {
    "*" = "ask";
    "context7-docs" = "allow";
  };
  allowToolPermission = {
    "*" = "allow";
    "resolve-library-id" = "allow";
    "query-docs" = "allow";
  };
  allowSkillPermission = {
    "*" = "allow";
    "context7-docs" = "allow";
  };
  makePermission = tool: skill: {
    external_directory = externalDirectoryPermission;
    inherit tool skill;
    path = pathPermission;
    read = "allow";
    grep = "allow";
    find = "allow";
    ls = "allow";
  };
  yoloPermission = {
    external_directory = "allow";
    path = pathPermission;
    read = "allow";
    write = "allow";
    edit = "allow";
    grep = "allow";
    find = "allow";
    ls = "allow";
    bash = "allow";
    web_search = "allow";
    tool = "allow";
    skill = "allow";
  };
  makeSandbox = writable: network: {
    enabled = true;
    inherit writable allowWrite denyRead network;
    askOnBlockedHost = true;
  };
  filteredNetwork = {
    allowedDomains = [];
    deniedDomains = [];
  };
  bootstrapNetwork = {
    allowedDomains = ["sandbox-proxy-bootstrap.invalid"];
    deniedDomains = [];
  };
in {
  "$schema" = "https://raw.githubusercontent.com/wynainfo/pi-permission-modes/v2.2.0/schemas/permission-mode.schema.json";
  defaultMode = "yolo";
  cycleOrder = [
    "default"
    "plan"
    "build"
    "yolo"
  ];
  modes = {
    default = {
      sandbox = makeSandbox true bootstrapNetwork;
      permission =
        makePermission askToolPermission askSkillPermission
        // {
          bash = "allow";
          write = "allow";
          edit = "allow";
        };
    };
    plan = {
      sandbox = makeSandbox false filteredNetwork;
      permission = makePermission askToolPermission askSkillPermission;
    };
    build = {
      sandbox = makeSandbox true filteredNetwork;
      permission =
        makePermission allowToolPermission allowSkillPermission
        // {
          bash = "allow";
          write = "allow";
          edit = "allow";
        };
    };
    yolo = {
      sandbox = {
        enabled = true;
        writable = true;
        inherit allowWrite denyRead;
      };
      permission = yoloPermission;
    };
  };
}
