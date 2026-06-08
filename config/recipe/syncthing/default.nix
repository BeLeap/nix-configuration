_: {
  hm = [
    ({config, ...}: {
      services.syncthing = {
        enable = true;

        settings = {
          devices = {
            beleap-m1air = {
              id = "GDUYEXA-YGTOHI2-P6HTI3P-YRIKT6X-OUC4OFR-3FDRD3R-NQVSDKZ-BHOZXA3";
            };
            beleap-s24 = {
              id = "G2ERWU6-3M4MXCI-EM3ZS5W-TX3A4I5-ERHRC7V-5FJG75F-7RVNKHF-JACTWA4";
            };
          };
          folders = {
            "${config.home.homeDirectory}/Sync" = {
              id = "sync";

              devices = [
                "beleap-m1air"
                "beleap-s24"
              ];
            };
          };
        };
      };
    })
  ];
}
