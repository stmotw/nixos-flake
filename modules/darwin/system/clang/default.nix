{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.clang;
in {
  options.mine.system.clang = {
    enable = lib.mkEnableOption "Enable clang";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      llvmPackages.clang
    ];
  };
}
