{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.apps.vscode;
in {
  options.mine.home-manager.apps.vscode = {
    enable = lib.mkEnableOption "Enable vscode";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        unstable.vscode
      ];

      stylix.targets.vscode.enable = false;

      programs.vscode = {
        enable = true;
        package = pkgs.unstable.vscode;
        mutableExtensionsDir = false;

        profiles.default = {
          enableUpdateCheck = false;
          enableExtensionUpdateCheck = false;

          userSettings = {
            "diffEditor.ignoreTrimWhitespace" = false;
            "diffEditor.renderSideBySide" = true;
            "editor.inlineSuggest.enabled" = true;
            "editor.fontFamily" = "'FiraMono Nerd Font', 'Fira Code', monospace";
            "editor.fontLigatures" = true;
            "editor.minimap.enabled" = false;
            "editor.rulers" = [99];
            "git.blame.editorDecoration.enabled" = true;
            "git.blame.statusBarItem.enabled" = false;
            "git.confirmSync" = false;
            "git.openRepositoryInParentFolders" = "never";
            "remote.SSH.remotePlatform" = {
              "fiddlebender" = "linux";
            };
            "telemetry.telemetryLevel" = "off";
            "terminal.integrated.allowedLinkSchemes" = [
              "file"
              "http"
              "https"
              "mailto"
              "vscode"
              "vscode-insiders"
              "docker-desktop"
            ];
            "terminal.integrated.scrollback" = 100000;
            "window.autoDetectColorScheme" = true;
            "workbench.preferredDarkColorTheme" = "Default Dark+";
            "workbench.preferredLightColorTheme" = "Default Light+";
            "workbench.startupEditor" = "none";
          };

          extensions =
            (with pkgs.unstable.vscode-extensions; [
              ms-vscode-remote.remote-ssh

              # languages
              jnoortheen.nix-ide
              rust-lang.rust-analyzer
              tamasfe.even-better-toml
              wholroyd.jinja

              # python
              ms-python.vscode-pylance
              ms-python.debugpy
              charliermarsh.ruff

              # utility
              streetsidesoftware.code-spell-checker
            ])
            ++ (with pkgs.vscode-extensions; [
              # from stable to avoid pygls/lsprotocol conflict
              ms-python.python
            ])
            ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "vscode-containers";
                publisher = "ms-azuretools";
                version = "2.4.1";
                sha256 = "02zqkdxazzppmj7pg9g0633fn1ima2qrb4jpb6pwir5maljlj31v";
              }
              {
                name = "yamlfmt";
                publisher = "bluebrown";
                version = "0.1.6";
                sha256 = "11vzk60zikjgylvkszzxahmdjs1zsgli3i30fz4w67f70akcirkb";
              }
              {
                name = "vscode-markdownlint";
                publisher = "DavidAnson";
                version = "0.61.1";
                sha256 = "0g0lfxcx7hkigs5780pjrbzwh2c616fcqygzlvwhvfsllj5j5vnw";
              }
              {
                name = "azure-pipelines";
                publisher = "ms-azure-devops";
                version = "1.261.1";
                sha256 = "111kqybs73nqav4b067dv2kvsgy67w1c31irjrxqxiqbyqaicj4l";
              }
              {
                name = "claude-code";
                publisher = "Anthropic";
                version = "2.1.49";
                sha256 = "184gwn4cza8w0cazf9z7s31kg2zz47lzwmc65qj1zzhc6pah0v7m";
              }
              {
                name = "code-spell-checker-russian";
                publisher = "streetsidesoftware";
                version = "2.2.4";
                sha256 = "1za6yszd47kp4jdnw86897d0qxsik5q2grvpaj7xl0rnknxxazsn";
              }
            ];
        };
      };
    };
  };
}
