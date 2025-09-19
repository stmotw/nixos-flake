{user, ...}: {
  config = {
    programs.home-manager.enable = true;

    home = {
      username = "${user.username}";
      homeDirectory = "${user.homeDir}";
      stateVersion = "25.05";
    };
  };
}
