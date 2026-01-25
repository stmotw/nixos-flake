{
  lib,
  pkgs,
  sec,
  ...
}: let
  inherit (lib.mine.options) enabled;
  homeDir = "/home/${sec.users.me.username}";
in {
  imports = [
    ../../overlays/rust
    ../../overlays/unstable
    ../../modules/shared/import.nix
    ../../modules/nixos/import.nix
    ../../modules/wsl/import.nix
    ../../modules/home/import.nix
  ];

  config = {
    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    mine = {
      user =
        enabled
        // sec.users.me
        // {
          homeDir = homeDir;
          home-manager = enabled;
          shell = {
            package = pkgs.zsh;
            starship = enabled;
          };
        };

      home-manager = {
        cli-tools = {
          commitizen = enabled;
          eza = enabled;
          git =
            enabled
            // lib.mine.configs.mkGitConfig {
              inherit sec homeDir;
              primaryUser = "me";
            };
          gnupg =
            enabled
            // lib.mine.configs.mkGnupgConfig {
              inherit pkgs sec;
              profiles = ["me"];
            };
          rust = enabled;
          ssh =
            enabled
            // {
              forwardGpgAgent = true;
              hosts = sec.hosts;
            };
          zig = enabled;
          zoxide = enabled;
        };

        system = {
          shell.zsh = enabled;
        };
      };

      cli-tools = {
        charm-freeze = enabled;
        claude-code = enabled;
        direnv = enabled;
        just = enabled;
        make = enabled;
      };

      services = {
        docker = enabled;
        vscode-server = enabled;
      };

      system = {
        gcc = enabled;
        fonts = enabled;
        security.sudonopass = enabled;
        services.openssh = enabled;
        shell.zsh = enabled;
        stylix = enabled;
        timezone = enabled // {location = sec.timeZone;};
        utils = enabled // {dev = true;};
        yubikey = enabled // {autoAttach = sec.wsl.yubikey.busid;};
      };

      windows = {
        start-menu = enabled;
        docker-desktop = enabled;
      };
    };
  };
}
