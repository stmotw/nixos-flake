{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.mine.cli-tools.git-credential-manager;
in {
  options.mine.cli-tools.git-credential-manager = {
    enable = lib.mkEnableOption "Git Credential Manager for secure credential storage";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git-credential-manager
    ];
  };
}
