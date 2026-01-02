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

      programs.eza = {
        enable = true;
        enableZshIntegration = config.mine.home-manager.system.shell.zsh.enable;

        colors = "auto";

        # TODO: migrate to stylix when support is ready:
        # https://github.com/nix-community/stylix/issues/545
        theme = {
          filekinds = {
            normal.foreground = "#${config.lib.stylix.colors.base07}";
            directory.foreground = "#${config.lib.stylix.colors.base16}";
            symlink.foreground = "#${config.lib.stylix.colors.base05}";
            pipe.foreground = "#${config.lib.stylix.colors.base06}";
            block_device.foreground = "#${config.lib.stylix.colors.base14}";
            char_device.foreground = "#${config.lib.stylix.colors.base13}";
            socket.foreground = "#${config.lib.stylix.colors.base03}";
            special.foreground = "#${config.lib.stylix.colors.base17}";
            executable.foreground = "#${config.lib.stylix.colors.base17}";
            mount_point.foreground = "#${config.lib.stylix.colors.base04}";
          };
          perms = {
            user_read.foreground = "#${config.lib.stylix.colors.base06}";
            user_write.foreground = "#${config.lib.stylix.colors.base04}";
            user_execute_file.foreground = "#${config.lib.stylix.colors.base17}";
            user_execute_other.foreground = "#${config.lib.stylix.colors.base17}";
            group_read.foreground = "#${config.lib.stylix.colors.base06}";
            group_write.foreground = "#${config.lib.stylix.colors.base04}";
            group_execute.foreground = "#${config.lib.stylix.colors.base17}";
            other_read.foreground = "#${config.lib.stylix.colors.base06}";
            other_write.foreground = "#${config.lib.stylix.colors.base04}";
            other_execute.foreground = "#${config.lib.stylix.colors.base17}";
            special_user_file.foreground = "#${config.lib.stylix.colors.base17}";
            special_other.foreground = "#${config.lib.stylix.colors.base04}";
            attribute.foreground = "#${config.lib.stylix.colors.base06}";
          };
          size = {
            major.foreground = "#${config.lib.stylix.colors.base06}";
            minor.foreground = "#${config.lib.stylix.colors.base16}";
            number_byte.foreground = "#${config.lib.stylix.colors.base06}";
            number_kilo.foreground = "#${config.lib.stylix.colors.base05}";
            number_mega.foreground = "#${config.lib.stylix.colors.base15}";
            number_giga.foreground = "#${config.lib.stylix.colors.base17}";
            number_huge.foreground = "#${config.lib.stylix.colors.base17}";
            unit_byte.foreground = "#${config.lib.stylix.colors.base06}";
            unit_kilo.foreground = "#${config.lib.stylix.colors.base15}";
            unit_mega.foreground = "#${config.lib.stylix.colors.base17}";
            unit_giga.foreground = "#${config.lib.stylix.colors.base17}";
            unit_huge.foreground = "#${config.lib.stylix.colors.base16}";
          };
          users = {
            user_you.foreground = "#${config.lib.stylix.colors.base13}";
            user_root.foreground = "#${config.lib.stylix.colors.base08}";
            user_other.foreground = "#${config.lib.stylix.colors.base17}";
            group_yours.foreground = "#${config.lib.stylix.colors.base05}";
            group_other.foreground = "#${config.lib.stylix.colors.base03}";
            group_root.foreground = "#${config.lib.stylix.colors.base08}";
          };
          links = {
            normal.foreground = "#${config.lib.stylix.colors.base16}";
            multi_link_file.foreground = "#${config.lib.stylix.colors.base15}";
          };
          git = {
            new.foreground = "#${config.lib.stylix.colors.base16}";
            modified.foreground = "#${config.lib.stylix.colors.base13}";
            deleted.foreground = "#${config.lib.stylix.colors.base08}";
            renamed.foreground = "#${config.lib.stylix.colors.base15}";
            typechange.foreground = "#${config.lib.stylix.colors.base17}";
            ignored.foreground = "#${config.lib.stylix.colors.base03}";
            conflicted.foreground = "#${config.lib.stylix.colors.base14}";
          };
        };
      };
    };
  };
}
