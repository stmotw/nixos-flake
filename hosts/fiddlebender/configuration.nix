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
    ../../modules/home/import.nix
    ../../modules/nixos/import.nix
    ../../modules/shared/import.nix
  ];

  config = {
    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

    # TODO: split into modules
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };
      };
      initrd.systemd.enable = true;
    };

    systemd.targets.multi-user.enable = true;

    networking.hostName = "fiddlebender";
    networking.networkmanager.enable = true;

    users = {
      mutableUsers = false;
      users.${sec.users.me.username} = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
      };
    };

    # Enable passwordless sudo.
    security.sudo.extraRules = [
      {
        users = ["${sec.users.me.username}"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

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
          zoxide = enabled;
        };

        system = {
          shell.zsh = enabled;
        };
      };

      cli-tools = {
        direnv = enabled;
        just = enabled;
      };

      services = {
      };

      system = {
        nix.flakes = enabled;
        shell.zsh = enabled;
        stylix = enabled;
        timezone = enabled // {location = sec.timeZone;};
        utils = enabled;
      };
    };
  };
}
