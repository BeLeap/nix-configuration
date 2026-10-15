# Make YOLO Pi's default permission mode

Set `defaultMode` in Pi's declarative `pi-permission-modes` configuration to `yolo`, so Pi starts with YOLO permissions by default.

## Startup-mode follow-up

The extension initializes its active mode from the stock `Default` mode before loading the global configuration, so `defaultMode` alone does not reliably affect fresh sessions. Seed `PI_PERMISSION_MODE` from the same declarative default in Pi's wrapper, while preserving any inherited value for child Pi processes.
