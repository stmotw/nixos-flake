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
    inputs.home-manager.nixosModules.home-manager
  ];

  config = lib.mkIf cfg.enable {
    home-manager = {
      useUserPackages = true;
      extraSpecialArgs = {
        inherit user;
      };
      users.${user.username}.imports = [./home.nix];
    };
  };
}
