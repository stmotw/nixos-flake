{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.eza;
in {
  options.mine.home-manager.cli-tools.eza = {
    enable = lib.mkEnableOption "eza configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        eza
      ];

      # https://github.com/eza-community/eza/issues/1224
      # On macOS, eza looks for theme.yml in ~/Library/Application Support/eza by default
      # Set environment variable to use XDG config location
      home.sessionVariables = lib.mkIf pkgs.stdenv.isDarwin {
        EZA_CONFIG_DIR = "\${HOME}/.config/eza";
      };

      programs.eza = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;

        colors = "auto";

        # TODO: migrate to stylix when support is ready:
        # https://github.com/nix-community/stylix/issues/545
        theme = {
          filekinds = {
            normal.foreground = "#${config.lib.stylix.colors.base07}";
            directory.foreground = "#${config.lib.stylix.colors.base0D}";
            symlink.foreground = "#${config.lib.stylix.colors.base05}";
            pipe.foreground = "#${config.lib.stylix.colors.base06}";
            block_device.foreground = "#${config.lib.stylix.colors.base14}";
            char_device.foreground = "#${config.lib.stylix.colors.base13}";
            socket.foreground = "#${config.lib.stylix.colors.base03}";
            special.foreground = "#${config.lib.stylix.colors.base0E}";
            executable.foreground = "#${config.lib.stylix.colors.base0B}";
            mount_point.foreground = "#${config.lib.stylix.colors.base04}";
          };
          perms = {
            user_read.foreground = "#${config.lib.stylix.colors.base0D}";
            user_write.foreground = "#${config.lib.stylix.colors.base07}";
            user_execute_file.foreground = "#${config.lib.stylix.colors.base0B}";
            user_execute_other.foreground = "#${config.lib.stylix.colors.base0B}";
            group_read.foreground = "#${config.lib.stylix.colors.base0D}";
            group_write.foreground = "#${config.lib.stylix.colors.base07}";
            group_execute.foreground = "#${config.lib.stylix.colors.base0B}";
            other_read.foreground = "#${config.lib.stylix.colors.base0D}";
            other_write.foreground = "#${config.lib.stylix.colors.base07}";
            other_execute.foreground = "#${config.lib.stylix.colors.base0B}";
            special_user_file.foreground = "#${config.lib.stylix.colors.base0E}";
            special_other.foreground = "#${config.lib.stylix.colors.base04}";
            attribute.foreground = "#${config.lib.stylix.colors.base06}";
          };
          size = {
            major.foreground = "#${config.lib.stylix.colors.base06}";
            minor.foreground = "#${config.lib.stylix.colors.base0D}";
            number_byte.foreground = "#${config.lib.stylix.colors.base06}";
            number_kilo.foreground = "#${config.lib.stylix.colors.base05}";
            number_mega.foreground = "#${config.lib.stylix.colors.base15}";
            number_giga.foreground = "#${config.lib.stylix.colors.base0A}";
            number_huge.foreground = "#${config.lib.stylix.colors.base08}";
            unit_byte.foreground = "#${config.lib.stylix.colors.base06}";
            unit_kilo.foreground = "#${config.lib.stylix.colors.base15}";
            unit_mega.foreground = "#${config.lib.stylix.colors.base0A}";
            unit_giga.foreground = "#${config.lib.stylix.colors.base0A}";
            unit_huge.foreground = "#${config.lib.stylix.colors.base08}";
          };
          users = {
            user_you.foreground = "#${config.lib.stylix.colors.base13}";
            user_root.foreground = "#${config.lib.stylix.colors.base08}";
            user_other.foreground = "#${config.lib.stylix.colors.base0E}";
            group_yours.foreground = "#${config.lib.stylix.colors.base05}";
            group_other.foreground = "#${config.lib.stylix.colors.base03}";
            group_root.foreground = "#${config.lib.stylix.colors.base08}";
          };
          links = {
            normal.foreground = "#${config.lib.stylix.colors.base0D}";
            multi_link_file.foreground = "#${config.lib.stylix.colors.base15}";
          };
          git = {
            new.foreground = "#${config.lib.stylix.colors.base0B}";
            modified.foreground = "#${config.lib.stylix.colors.base13}";
            deleted.foreground = "#${config.lib.stylix.colors.base08}";
            renamed.foreground = "#${config.lib.stylix.colors.base15}";
            typechange.foreground = "#${config.lib.stylix.colors.base0E}";
            ignored.foreground = "#${config.lib.stylix.colors.base03}";
            conflicted.foreground = "#${config.lib.stylix.colors.base14}";
          };
          punctuation.foreground = "#${config.lib.stylix.colors.base0C}";
        };
      };
    };
  };
}
