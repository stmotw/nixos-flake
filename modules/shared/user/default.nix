{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.mine.options) mkOpt;
  inherit (config.mine) user;
in {
  options.mine.user = {
    enable = lib.mkEnableOption "Enable user";
    username = mkOpt lib.types.str "User account name";
    name = mkOpt lib.types.str "Full user name";
    email = mkOpt lib.types.str "User email";
    homeDir = mkOpt lib.types.str "Home directory path";
    home-manager.enable = lib.mkEnableOption "Enable home-manager";
    shell = lib.mkOption {
      description = "Shell config for user";
      type = lib.types.submodule {
        options = {
          package = mkOpt lib.types.package "User shell";
          starship = {
            enable = lib.mkEnableOption "Enable starship";
            aliases = lib.mkOption {
              type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
              default = {};
              description = "Username and hostname aliases for starship prompt";
            };
          };
        };
      };
    };
  };
}
