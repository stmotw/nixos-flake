{
  config,
  lib,
  pkgs,
  sec,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.user.shell.starship;
in {
  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        starship
      ];

      programs.starship = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;

        settings = {
          # https://github.com/starship/starship/issues/6761
          # using base13-17 instead of 0A-0F as a workaround
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
            aliases = sec.work.aliases.username;
          };
          hostname = {
            ssh_only = false;
            ssh_symbol = "ssh:";
            format = "[@$ssh_symbol$hostname ]($style)";
            style = "fg:base06 bg:base01";
            aliases = sec.work.aliases.hostname;
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
      };
    };
  };
}
