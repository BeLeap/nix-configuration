let
  allowWrite = [
    "."
    "/tmp"
    "~/.config/jj"
  ];
  denyRead = [
    "~/.ssh"
    "~/.aws"
    "~/.gnupg"
    "~/.pi/agent"
    ".env"
    ".env.*"
    "**/.env"
    "**/.env.*"
    ".envrc*"
    "**/.envrc*"
    ".direnv/**"
    "**/.direnv/**"
  ];
  pathPermission = {
    "*" = "allow";
    ".env" = "deny";
    ".env.*" = "deny";
    "**/.env" = "deny";
    "**/.env.*" = "deny";
    ".envrc*" = "deny";
    "**/.envrc*" = "deny";
    ".direnv/**" = "deny";
    "**/.direnv/**" = "deny";
  };
  externalDirectoryPermission = {
    "*" = "ask";
    "~/.agent/skills" = "allow";
    "~/.agent/skills/**" = "allow";
  };
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
  };
  yoloPermission = {
    external_directory = "allow";
    path = {"*" = "allow";};
    read = "allow";
    write = "allow";
    edit = "allow";
    grep = "allow";
    find = "allow";
    ls = "allow";
    bash = {"*" = "allow";};
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
  defaultMode = "build";
  cycleOrder = [
    "default"
    "plan"
    "build"
    "yolo"
  ];
  modes = {
    default = {
      sandbox = makeSandbox true bootstrapNetwork;
      permission = makePermission askToolPermission askSkillPermission;
    };
    plan = {
      sandbox = makeSandbox false filteredNetwork;
      permission = makePermission askToolPermission askSkillPermission;
    };
    build = {
      sandbox = makeSandbox true filteredNetwork;
      permission = makePermission allowToolPermission allowSkillPermission;
    };
    yolo = {
      sandbox = {
        enabled = false;
        writable = true;
      };
      bypassProtectedPaths = true;
      permission = yoloPermission;
    };
  };
}
