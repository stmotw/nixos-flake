{
  config,
  lib,
  pkgs,
  sec,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.cli-tools.git;
in {
  options.mine.home-manager.cli-tools.git = {
    enable = lib.mkEnableOption "git configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      home.packages = with pkgs; [
        gh
        git
        git-crypt
      ];

      programs.git = {
        enable = true;

        userName = "${user.name}";
        userEmail = "${user.email}";

        aliases = {
          s = "status";
          co = "checkout";
          cob = "checkout -b";
          br = "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate";
          l = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
          c = "commit -v";
        };

        extraConfig = {
          core.editor = "nvim";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };

        difftastic = {
          enable = true;
          background = "dark";
          display = "side-by-side";
        };

        includes = [
          {
            condition = "gitdir:~/code/ai71/";
            contents.user.email = "${sec.users.work.email}";
          }
        ];
      };
    };
  };
}
