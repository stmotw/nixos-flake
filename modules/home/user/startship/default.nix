{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.user.shell.starship;

  darkColors = config.mine.system.stylix.darkBase16Scheme;
  lightColors = config.mine.system.stylix.lightBase16Scheme;

  mkStarshipPalette = scheme: {
    base00 = "#${scheme.base00}";
    base01 = "#${scheme.base01}";
    base02 = "#${scheme.base02}";
    base03 = "#${scheme.base03}";
    base04 = "#${scheme.base04}";
    base05 = "#${scheme.base05}";
    base06 = "#${scheme.base06}";
    base07 = "#${scheme.base07}";
    base08 = "#${scheme.base08}";
    base09 = "#${scheme.base09}";
    base0A = "#${scheme.base0A}";
    base0B = "#${scheme.base0B}";
    base0C = "#${scheme.base0C}";
    base0D = "#${scheme.base0D}";
    base0E = "#${scheme.base0E}";
    base0F = "#${scheme.base0F}";
    base13 = "#${scheme.base0A}";
    base15 = "#${scheme.base0C}";
    base16 = "#${scheme.base0D}";
  };

  mkStarshipConfig = scheme:
    (pkgs.formats.toml {}).generate "starship.toml"
    (starshipSettings // {palettes.base16 = mkStarshipPalette scheme;});

  # https://github.com/starship/starship/issues/6761
  # using base13-17 instead of 0A-0F as a workaround
  starshipSettings = {
    palette = "base16";

    format = lib.concatStrings [
      "[](fg:base01)"
      "$os"
      "$username"
      "$hostname"
      "[](fg:base01 bg:base02)"
      "$directory"
      "$git_branch"
      "$git_commit"
      "$git_state"
      "$git_status"
      "[](fg:base02 bg:base03)"
      "$time"
      "[](fg:base03)"
      "$cmd_duration"
      "$line_break"
      "$python"
      "$nix_shell"
      "$character"
    ];

    os = {
      disabled = false;
      style = "fg:base05 bg:base01";
      symbols = {
        Windows = "";
        Macos = "󰀵";
        NixOS = "󱄅";
      };
    };
    username = {
      style_root = "fg:base08 bg:base01";
      style_user = "fg:base06 bg:base01";
      format = "[ $user]($style)";
      show_always = true;
      aliases = cfg.aliases.username or {};
    };
    hostname = {
      ssh_only = false;
      ssh_symbol = "ssh:";
      format = "[@$ssh_symbol$hostname ]($style)";
      style = "fg:base06 bg:base01";
      aliases = cfg.aliases.hostname or {};
    };
    directory = {
      format = "[ $path ]($style)[$read_only]($read_only_style)";
      style = "fg:base16 bg:base02";
      read_only_style = "fg:base08 bg:base02";
    };
    git_branch = {
      format = "[$symbol$branch ]($style)";
      symbol = "";
      style = "fg:base16 bg:base02";
    };
    git_commit = {
      format = "[#$hash$tag ]($style)";
      style = "fg:base15 bg:base02";
    };
    git_state = {
      format = "[$state $progress_current/$progress_total ]($style)";
      style = "fg:base13 bg:base02";
    };
    git_status = {
      format = "[$all_status$ahead_behind ]($style)";
      style = "fg:base08 bg:base02";
    };
    time = {
      format = "[ $time ]($style)";
      style = "fg:base06 bg:base03";
      disabled = false;
    };
    cmd_duration = {
      format = "[ $duration]($style)";
      style = "fg:base05";
    };
    python = {
      format = "[$symbol $virtualenv ]($style)";
      symbol = "";
      style = "base05";
    };
    nix_shell = {
      format = "[$symbol $name ]($style)";
      style = "base16";
      symbol = "󱄅";
    };

    character = {
      success_symbol = "[❯](base07)";
      error_symbol = "[❯](base08)";
      vimcmd_symbol = "[❯](base07)";
    };

    follow_symlinks = false;
    package.disabled = true;
    jobs.disabled = true;
  };
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        starship
      ];

      stylix.targets.starship.enable = false;

      programs.starship = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;
      };

      xdg.configFile."starship-dark.toml".source = mkStarshipConfig darkColors;
      xdg.configFile."starship-light.toml".source = mkStarshipConfig lightColors;

      programs.zsh.initContent = lib.mkIf config.mine.home-manager.system.shell.zsh.enable (
        if pkgs.stdenv.isDarwin
        then ''
          function _starship_theme_precmd() {
            if defaults read -g AppleInterfaceStyle &>/dev/null 2>&1; then
              export STARSHIP_CONFIG="$HOME/.config/starship-dark.toml"
            else
              export STARSHIP_CONFIG="$HOME/.config/starship-light.toml"
            fi
          }
          precmd_functions+=(_starship_theme_precmd)
        ''
        else ''
          export STARSHIP_CONFIG="$HOME/.config/starship-dark.toml"
        ''
      );
    };
  };
}
