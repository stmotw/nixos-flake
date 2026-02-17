{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mine.cli-tools.helm;
in {
  options.mine.cli-tools.helm = {
    enable = lib.mkEnableOption "Enable helm, the Kubernetes package manager";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kubernetes-helm
    ];
  };
}
