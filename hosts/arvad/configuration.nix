{
  lib,
  pkgs,
  sec,
  ...
}: let
  inherit (lib.mine.options) enabled;
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
          homeDir = "/home/${sec.users.me.username}";
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
          git = enabled;
          rust = enabled;
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
