{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.home-manager.system.shell.zsh;
in {
  options.mine.home-manager.system.shell.zsh = {
    enable = lib.mkEnableOption "zsh configs";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user.username} = {
      programs.zsh = {
        enable = true;

        history = {
          append = true;
          expireDuplicatesFirst = true;
          extended = true;
          ignoreAllDups = true;
          share = true;
        };
        historySubstringSearch.enable = true;

        # historySubstringSearch.enable does not set correct keybindings
        initContent = ''
          bindkey '^[[A' history-substring-search-up
          bindkey '^[OA' history-substring-search-up
          bindkey '^[[B' history-substring-search-down
          bindkey '^[OB' history-substring-search-down
        '';

        syntaxHighlighting.enable = true;

        shellAliases = {
          cp = "cp -iv";
          mv = "mv -iv";
          rm = "rm -v";
        };
      };
    };
  };
}
