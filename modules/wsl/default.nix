{
  config,
  hostname,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.wsl
  ];

  config = {
    # https://nix-community.github.io/NixOS-WSL/options.html
    wsl = {
      enable = true;
      defaultUser = config.mine.user.username;

      wslConf = {
        network.hostname = hostname;
        interop.appendWindowsPath = false;
      };
    };
  };
}
