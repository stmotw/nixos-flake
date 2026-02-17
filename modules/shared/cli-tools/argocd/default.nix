{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.argocd;
in {
  options.mine.cli-tools.argocd = {
    enable = lib.mkEnableOption "Enable argocd, the Argo CD CLI";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      argocd
    ];
  };
}
