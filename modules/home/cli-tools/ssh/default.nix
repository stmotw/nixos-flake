{
  config,
  lib,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.ssh;
in {
  options.mine.home-manager.cli-tools.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";
    forwardGpgAgent = lib.mkEnableOption "GPG agent forwarding to all hosts";
    hosts = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      description = "SSH host configurations (matchBlocks)";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username}.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = lib.mapAttrs (_: hostCfg:
        hostCfg
        // lib.optionalAttrs cfg.forwardGpgAgent {
          remoteForwards = [
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent";
              host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
            }
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
              host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            }
          ];
        })
      cfg.hosts;
    };
  };
}
