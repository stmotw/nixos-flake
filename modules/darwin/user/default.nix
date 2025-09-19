{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (config.mine) user;
in {
  config = lib.mkIf user.enable {
    users.knownUsers = ["${user.username}"];

    users.users."${user.username}" = {
      name = "${user.username}";
      home = "/Users/${user.username}";
      isHidden = false;
      uid = 502;
      openssh.authorizedKeys.keyFiles = [inputs.ssh-keys.outPath];
      shell = user.shell.package;
    };
  };
}
