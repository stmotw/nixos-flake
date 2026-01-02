{
  config,
  lib,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.services.docker;
in {
  options.mine.services.docker = {
    enable = lib.mkEnableOption "Enable docker";
  };

  config = lib.mkIf cfg.enable {
    users.users.${user.username}.extraGroups = lib.mkIf user.enable ["docker"];

    virtualisation = {
      oci-containers.backend = "docker";
      docker = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
    };
  };
}
