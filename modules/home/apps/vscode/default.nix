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
                version = "2.1.0";
                sha256 = "1a3kzj088i78dsmwcd4l462nc0kmiz8vngrhsl8mbz4vrl04p8pp";
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
                version = "0.60.0";
                sha256 = "18fw4snqfa7bys04r8748vv6x7gfaq2bqvhqm9x3z1fsf7mimv06";
              }
              {
                name = "vscode-python-envs";
                publisher = "ms-python";
                version = "1.2.0";
                sha256 = "1sqnpbhjyp8cl4qxvfwjqcd5m7zqsfnxwaapm8bvpfvaxhkdy279";
              }
              {
                name = "azure-pipelines";
                publisher = "ms-azure-devops";
                version = "1.249.0";
                sha256 = "1154j7yfin2iznlngd9lcw0lsgmy5jx9qaghrjf0fv61sxkj7gvs";
              }
              {
                name = "claude-code";
                publisher = "Anthropic";
                version = "1.0.100";
                sha256 = "1i0mzbifwlvsihb586rfisfgm7z744jk5slgla11njcwk4y2h8pa";
              }
              {
                name = "code-spell-checker-russian";
                publisher = "streetsidesoftware";
                version = "2.2.4";
                sha256 = "1za6yszd47kp4jdnw86897d0qxsik5q2grvpaj7xl0rnknxxazsn";
              }
              {
                name = "copilot";
                publisher = "GitHub";
                version = "1.364.1769";
                sha256 = "0mznj8njgfqsyijbglhjvybsvpqgnf71iy5l3vh8f5iczsxn6jx4";
              }
              {
                name = "copilot-chat";
                publisher = "GitHub";
                version = "0.30.3";
                sha256 = "09g6mjciqh14kg4a63vdm7ll5a0vj810qihiyszz5iwhdj91ds1j";
              }
            ];
        };
      };
    };
  };
}
