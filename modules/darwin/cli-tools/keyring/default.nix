{
  lib,
  config,
  ...
}: let
  inherit (config.mine) user;
  cfg = config.mine.cli-tools.keyring;
in {
  options.mine.cli-tools.keyring = {
    enable = lib.mkEnableOption "Install keyring with Azure artifacts support";
  };

  config = lib.mkIf cfg.enable {
    homebrew.brews = ["dotnet"];

    home-manager.users.${user.username} = {
      config,
      pkgs,
      ...
    }: {
      home.activation.keyringSetup = config.lib.dag.entryAfter ["writeBoundary"] ''
        # Install keyring with artifacts-keyring plugin via uv
        if ! $DRY_RUN_CMD ${pkgs.unstable.uv}/bin/uv tool list | grep -q "keyring"; then
          $VERBOSE_ECHO "Installing keyring with artifacts-keyring..."
          $DRY_RUN_CMD ${pkgs.unstable.uv}/bin/uv tool install keyring --with artifacts-keyring
        else
          $VERBOSE_ECHO "keyring is already installed"
        fi

        # Install Azure artifacts credential provider
        if ! $DRY_RUN_CMD test -d ${user.homeDir}/.nuget/plugins; then
          $VERBOSE_ECHO "Installing Azure artifacts credential provider..."
          $DRY_RUN_CMD sh -c "$(curl -fsSL https://aka.ms/install-artifacts-credprovider.sh)"
        else
          $VERBOSE_ECHO "Azure artifacts credential provider is already installed"
        fi
      '';
    };
  };
}
