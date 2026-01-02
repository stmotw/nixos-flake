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
          };

          alias = {
            s = "status";
            co = "checkout";
            cob = "checkout -b";
            br = "branch --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authoremail)]' --sort=-committerdate";
            l = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %ae%C(reset)%C(bold yellow)%d%C(reset)' --all";
            c = "commit -v";
          };

          core.editor = "nvim";
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        };

        includes = [
          {
            condition = "gitdir:${user.homeDir}/code/ai71/**";
            contents = {
              user.email = "${sec.users.ai71.email}";
              user.signingKey = "${sec.ai71.signingKey}";
              commit.gpgSign = true;
            };
          }
          {
            condition = "gitdir:${user.homeDir}/code/motw/**";
            contents.user.email = "${sec.users.me.email}";
          }
        ];
      };
    };
  };
}
