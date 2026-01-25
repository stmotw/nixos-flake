{
  config,
  lib,
  sec,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.ssh;
in {
  options.mine.home-manager.cli-tools.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";
    forwardGpgAgent = lib.mkEnableOption "GPG agent forwarding to all hosts";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username}.programs.ssh = {
      enable = true;
      matchBlocks = lib.mapAttrs (_: hostCfg:
        hostCfg
        // {
          extraOptions = lib.mkIf cfg.forwardGpgAgent {
            RemoteForward = "/run/user/1000/gnupg/S.gpg-agent /run/user/1000/gnupg/S.gpg-agent.extra";
          };
        })
      cfg.hosts;
    };
  };
}
