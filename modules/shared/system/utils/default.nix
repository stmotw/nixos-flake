{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.utils;
  dev = with pkgs; [
    alejandra
    glow
    jq
    shellcheck
    statix
  ];
in {
  options.mine.system.utils = {
    enable = lib.mkEnableOption "system utils";
    dev = lib.mkEnableOption "Developer focused tooling";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        curl
        fzf
        neovim
        ripgrep
        wget
      ]
      ++ lib.optionals cfg.dev dev;
  };
}
