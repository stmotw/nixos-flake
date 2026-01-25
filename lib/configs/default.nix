{lib}: {
  ## Git configuration helper
  ##
  ## ```nix
  ## git = enabled // lib.mine.configs.mkGitConfig { inherit sec homeDir; primaryUser = "me"; };
  ## ```
  mkGitConfig = {
    sec,
    homeDir,
    primaryUser,
  }: {
    signingKey = sec.signingKey.${primaryUser};
    includes =
      lib.mapAttrsToList (name: user: {
        condition = "gitdir:${homeDir}/code/${name}/**";
        contents = {
          user.email = user.email;
          user.signingKey = sec.signingKey.${name};
        };
      })
      sec.users;
  };

  ## GnuPG configuration helper
  ##
  ## ```nix
  ## gnupg = enabled // lib.mine.configs.mkGnupgConfig { inherit pkgs sec; profiles = ["me"]; };
  ## ```
  mkGnupgConfig = {
    pkgs,
    sec,
    profiles,
  }: {
    ssh = true;
    publicKeys = map (p: pkgs.fetchurl sec.gpgPublicKey.${p}) profiles;
  };
}
