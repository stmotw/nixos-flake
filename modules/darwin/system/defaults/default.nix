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

        largesize = 24;
        mineffect = "scale";
        minimize-to-application = true;
        # persistent-apps = [];

        orientation = "right";
        showhidden = true;
        tilesize = 48;
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
        ShowSeconds = true;
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
