use std::collections::BTreeMap;
use zellij_tile::prelude::*;

#[derive(Default)]
struct ConfigReloader;

impl ZellijPlugin for ConfigReloader {
    fn load(&mut self, _configuration: BTreeMap<String, String>) {
        request_permission(&[PermissionType::Reconfigure]);
    }

    fn pipe(&mut self, _pipe_message: PipeMessage) -> bool {
        reload_config_file();
        false
    }
}

register_plugin!(ConfigReloader);
