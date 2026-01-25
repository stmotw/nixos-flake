{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.git;
in {
  options.mine.home-manager.cli-tools.git = {
    enable = lib.mkEnableOption "git configs";
    signingKey = lib.mkOption {
      type = lib.types.str;
      description = "Default GPG signing key";
    };
    includes = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = "Conditional git configuration includes";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        gh
        git
        git-crypt
      ];

      programs.difftastic = {
        enable = true;
        git.enable = true;
        options = {
          background = "dark";
          display = "side-by-side";
        };
      };

      programs.git = {
        enable = true;

        settings = {
          user = {
            name = "${user.name}";
            email = "${user.email}";
            signingKey = cfg.signingKey;
          };

          alias = {
            s = "status";
            co = "checkout";
            cob = "checkout -b";
            br = "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authoremail)]' --sort=-committerdate";
            l = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %ae%C(reset)%C(bold yellow)%d%C(reset)' --all";
            c = "commit -v";
          };

          commit.gpgSign = true;
          core.editor = "nvim";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };

        includes = cfg.includes;
      };
    };
  };
}
