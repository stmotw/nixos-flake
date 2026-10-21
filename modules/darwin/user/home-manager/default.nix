{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.user.home-manager;
in {
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];

  config = lib.mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${user.username} = {
        programs.home-manager.enable = true;
        home = {
          username = user.username;
          homeDirectory = user.homeDir;
          stateVersion = "25.05";
        };
      };
    };
  };
}
