{
  config,
  lib,
  ...
}: let
  cfg = config.mine.system.defaults;
in {
  options.mine.system.defaults = {
    enable = lib.mkEnableOption "Enable MacOS defaults";
  };

  config = lib.mkIf cfg.enable {
    system.defaults = {
      dock = {
        autohide = true;
        autohide-delay = 0.24;
        autohide-time-modifier = 0.5;

        largesize = 48;
        mineffect = "scale";
        minimize-to-application = true;
        mru-spaces = false;
        persistent-apps = [
          # TODO add options
          "/Applications/Notion.app"
          "/Applications/Microsoft Edge.app"
          "/Applications/Slack.app"
          # TODO link kitty from nixos
          # (lib.mkIf config.mine.home-manager.apps.kitty.enable "/Applications/kitty.app")
          # TODO add vscode from nixos
          "/Applications/Telegram.app"
        ];

        orientation = "right";
        showhidden = true;
        tilesize = 96;
      };

      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "clmv";
        FXRemoveOldTrashItems = true;
        ShowHardDrivesOnDesktop = false;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      loginwindow.GuestEnabled = false;

      menuExtraClock = {
        FlashDateSeparators = false;
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
      };

      NSGlobalDomain = {
        AppleICUForce24HourTime = true;
      };

      screencapture = {
        location = "~/Pictures/Screenshots";
      };
    };
  };
}
