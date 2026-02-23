{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
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
        persistent-apps =
          [
            # Pre-installed by jumpcloud on AI71 mac
            "/Applications/Notion.app"
            "/Applications/Firefox.app"
            "/Applications/Slack.app"
          ]
          ++ lib.optional config.mine.apps.telegram.enable "/Applications/Telegram.app"
          ++ lib.optional config.mine.home-manager.apps.kitty.enable "${pkgs.kitty}/Applications/kitty.app"
          ++ lib.optional config.mine.home-manager.apps.vscode.enable "${pkgs.unstable.vscode}/Applications/Visual Studio Code.app"
          ++ lib.optional config.mine.services.docker.enable "/Applications/Docker.app"
          ++ lib.optional config.mine.apps._1password.enable "/Applications/1Password.app"
          ++ lib.optional config.mine.apps.bitwarden.enable "/Applications/Bitwarden.app";

        orientation = "right";
        showhidden = true;
        show-recents = false;
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
        AppleInterfaceStyle = "Dark";
        AppleMetricUnits = 1;
      };

      screencapture = {
        location = "~/Pictures/Screenshots";
      };

      SoftwareUpdate = {
        AutomaticallyInstallMacOSUpdates = true;
      };
    };

    system.activationScripts.postActivation.text = lib.mkIf (config.mine.system.stylix.wallpaper != null) ''
      osascript -e 'tell application "System Events" to tell every desktop to set picture to POSIX file "${config.mine.system.stylix.wallpaper}"'
    '';
  };
}
