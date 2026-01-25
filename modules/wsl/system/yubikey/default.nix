# kudos https://lgug2z.com/articles/yubikey-passthrough-on-wsl2-with-full-fido2-support/
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mine.system.yubikey;
  usbipd-win-auto-attach = ./auto-attach.sh;
in {
  options.mine.system.yubikey = {
    autoAttach = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Auto attach devices with provided Bus IDs.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      linuxPackages.usbip
    ];

    services.pcscd.enable = true;
    services.udev = {
      enable = true;
      packages = [pkgs.yubikey-personalization];
      extraRules = ''
        SUBSYSTEM=="usb", MODE="0666"
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", TAG+="uaccess", MODE="0666"
      '';
    };

    systemd = {
      services."usbip-auto-attach@" = {
        description = "Auto attach device having busid %i with usbip";
        after = ["network.target"];

        scriptArgs = "%i";
        path = [pkgs.linuxPackages.usbip];

        script = ''
          busid="$1"
          ip="$(grep nameserver /etc/resolv.conf | cut -d' ' -f2)"

          echo "Starting auto attach for busid $busid on $ip."
          source ${usbipd-win-auto-attach} "$ip" "$busid"
        '';
      };

      targets.multi-user.wants = map (busid: "usbip-auto-attach@${busid}.service") cfg.autoAttach;
    };
  };
}
