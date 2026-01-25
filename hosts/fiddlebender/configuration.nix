{
  inputs,
  lib,
  pkgs,
  sec,
  ...
}: let
  inherit (lib.mine.options) enabled;
in {
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
    ./hardware-configuration.nix
    ../../overlays/unstable
    ../../modules/shared/import.nix
    ../../modules/nixos/import.nix
    ../../modules/home/import.nix
  ];

  config = {
    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

    # TODO: split into modules
    systemd.targets.multi-user.enable = true;

    # Disable autologin.
    services.getty.autologinUser = null;

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [22];
    # /end TODO

    mine = {
      user =
        enabled
        // sec.users.me
        // {
          homeDir = "/home/${sec.users.me.username}";
          home-manager = enabled;
          shell = {
            package = pkgs.zsh;
            starship = enabled;
          };
        };

      home-manager = {
        cli-tools = {
          eza = enabled;
          git = enabled;
          gnupg =
            enabled
            // {
              publicKeys = map pkgs.fetchurl (with sec.gpgPublicKey; [me]);
            };
          zoxide = enabled;
        };

        system = {
          shell.zsh = enabled;
        };
      };

      cli-tools = {
      };

      services = {
      };

      system = {
        security.sudonopass = enabled;
        services.openssh = enabled;
        shell.zsh = enabled;
        stylix = enabled;
        timezone = enabled // {location = sec.timeZone;};
        utils = enabled;
      };
    };
  };
}
