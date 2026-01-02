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
      primaryUser = "${sec.users.work.username}";
    };
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";

    mine = {
      user =
        enabled
        // sec.users.work
        // {
          homeDir = "/Users/${sec.users.work.username}";
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
          eza = enabled;
          git = enabled;
          rust = enabled;
          zoxide = enabled;
        };

        system = {
          shell.zsh = enabled;
        };
      };

      apps = {
        ollama = enabled;
        steam = enabled;
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
      };
    };
  };
}
