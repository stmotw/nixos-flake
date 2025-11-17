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
    ../../modules/darwin/import.nix
    ../../modules/home/import.nix
  ];

  config = {
    system = {
      stateVersion = 6;
      primaryUser = "${sec.users.ai71.username}";
    };
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

    mine = {
      user =
        enabled
        // sec.users.ai71
        // {
          homeDir = "/Users/${sec.users.ai71.username}";
          home-manager = enabled;
          shell = {
            package = pkgs.zsh;
            starship = enabled;
          };
        };

      home-manager = {
        apps = {
          kitty = enabled;
          vscode = enabled;
        };

        cli-tools = {
          az = enabled;
          commitizen = enabled;
          cruft = enabled;
          eza = enabled;
          git = enabled;
          ruff = enabled;
          rust = enabled;
          uv = enabled;
          zig = enabled;
          zoxide = enabled;
        };

        system = {
          shell.zsh = enabled;
        };
      };

      apps = {
        pgadmin = enabled;
        telegram = enabled;
      };

      cli-tools = {
        charm-freeze = enabled;
        claude-code = enabled;
        direnv = enabled;
        just = enabled;
        homebrew = enabled;
      };

      services = {
        docker = enabled;
      };

      system = {
        defaults = enabled;
        fonts = enabled;
        security.touchsudo = enabled;
        shell.zsh = enabled;
        stylix = enabled;
        timezone = enabled // {location = sec.timeZone;};
        utils = enabled // {dev = true;};
        yubikey = enabled;
      };
    };
  };
}
