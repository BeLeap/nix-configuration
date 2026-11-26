_: {
  home = [
    ({config, ...}: {
      services.syncthing = {
        enable = true;

        settings = {
          devices = {
            beleap-m1air = {
              id = "GDUYEXA-YGTOHI2-P6HTI3P-YRIKT6X-OUC4OFR-3FDRD3R-NQVSDKZ-BHOZXA3";
            };
            beleap-macmini = {
              id = "LPH36O4-GRJBFSX-I3SRYDQ-D3U4OUI-CA6C267-6BWMZJT-GQFVQHT-ZMHPCQI";
            };
            beleap-s24 = {
              id = "M2CBGUZ-SBCTLSO-577REHY-W5CE2PC-TFVSXHV-Z234NUB-PNF4G3V-YH4PUA6";
            };
            beleap-ipad = {
              id = "QTG36Q4-TRUP4O2-HVZTTKA-Z2SWAA7-4AFTWMS-3QVEMSY-ITB42OY-ZAIAYQF";
            };
          };
          folders = {
            "${config.home.homeDirectory}/Documents/Obsidian" = {
              id = "obsidian";

              devices = [
                "beleap-m1air"
                "beleap-macmini"
                "beleap-s24"
                "beleap-ipad"
              ];
            };
            "${config.home.homeDirectory}/Sync" = {
              id = "sync";

              devices = [
                "beleap-m1air"
                "beleap-macmini"
                "beleap-s24"
                "beleap-ipad"
              ];
            };
          };
        };
      };
    })
  ];
}
