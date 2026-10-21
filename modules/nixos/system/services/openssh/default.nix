{
  config,
  lib,
  ...
}: let
  cfg = config.mine.system.services.openssh;
in {
  options.mine.system.services.openssh = {
    enable = lib.mkEnableOption "Enable OpenSSH";
  };

  config = lib.mkIf cfg.enable {
    # Passwordless sudo when SSH'ing with keys
    security.pam.sshAgentAuth.enable = true;

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkDefault "no";
        # Allow GPG agent socket forwarding by removing stale sockets
        StreamLocalBindUnlink = "yes";
      };
    };
  };
}
