{
  config,
  inputs,
  lib,
  ...
}: let
  cfg = config.mine.system.services.openssh;
in {
  options.mine.system.services.openssh = {
    enable = lib.mkEnableOption "Enable OpenSSH";
    root = lib.mkEnableOption "Allow root login via SSH Keys";
  };

  config = lib.mkIf cfg.enable {
    users.users.root.openssh.authorizedKeys.keyFiles = lib.mkIf cfg.root [inputs.ssh-keys.outPath];

    # Passwordless sudo when SSH'ing with keys
    security.pam.sshAgentAuth.enable = true;

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin =
          if cfg.root
          then "prohibit-password"
          else lib.mkDefault "no";
        # Allow GPG agent socket forwarding by removing stale sockets
        StreamLocalBindUnlink = "yes";
      };
    };
  };
}
