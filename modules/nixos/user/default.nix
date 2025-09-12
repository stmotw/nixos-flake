{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.mine) user;
in {
  config = lib.mkIf user.enable {
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    users.groups.${user.username} = {};

    users.users.${user.username} = {
      isNormalUser = true;
      createHome = true;
      uid = 1000;
      openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
      group = "${user.username}";
      extraGroups = ["wheel"];
      shell = user.shell.package;
    };
  };
}
