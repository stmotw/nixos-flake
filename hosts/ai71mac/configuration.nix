{
  lib,
  pkgs,
  sec,
  ...
}: let
  inherit (lib.mine.options) enabled;
  homeDir = "/Users/${sec.users.ai71.username}";
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
          homeDir = homeDir;
          home-manager = enabled;
          shell = {
            package = pkgs.zsh;
            starship = enabled // {aliases = sec.aliases.ai71;};
          };
        };

      home-manager = {
        apps = {
          kitty = enabled;
          vscode = enabled;
        };

        cli-tools = {
          _1password = enabled;
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
              profiles = ["me" "ai71"];
            };
          ruff = enabled;
          rust = enabled;
          ssh =
            enabled
            // {
              forwardGpgAgent = true;
              hosts = sec.hosts;
            };
          uv = enabled;
          zig = enabled;
          zoxide = enabled;
        };

        system = {
          shell.zsh = enabled;
        };
      };

      apps = {
        _1password = enabled;
        bitwarden = enabled;
        pgadmin = enabled;
        telegram = enabled;
        yubico-authenticator = enabled;
      };

      cli-tools = {
        az = enabled; # TODO: delete after switching to 1Password
        charm-freeze = enabled;
        claude-code = enabled;
        direnv = enabled;
        glab = enabled;
        just = enabled;
        make = enabled;
        homebrew = enabled;
      };

      services = {
        docker = enabled;
      };

      system = {
        defaults = enabled;
        gcc = enabled;
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
