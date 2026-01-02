{pkgs, ...}: {
  nix =
    if pkgs.stdenv.isDarwin
    then {optimise.automatic = true;}
    else {settings.auto-optimize-store = true;};
}
