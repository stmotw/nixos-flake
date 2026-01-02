{
  lib,
  config,
  ...
}: let
  cfg = config.mine.services.vscode-server;
in {
  options.mine.services.vscode-server = {
    enable = lib.mkEnableOption "Enable vscode server";
  };

  config = lib.mkIf cfg.enable {
    # Required for VSCode Remote
    # https://nix-community.github.io/NixOS-WSL/how-to/vscode.html
    programs.nix-ld.enable = true;
  };
}
