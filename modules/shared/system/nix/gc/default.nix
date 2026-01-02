{
  lib,
  pkgs,
  ...
}: {
  nix.gc =
    {
      automatic = true;
      options = "--delete-older-than 7d";
    }
    // (
      if pkgs.stdenv.isDarwin
      then {
        interval = {
          Hour = 9;
          Minute = 1;
        };
      }
      else {dates = "*-*-* 09:01:00";}
    );
}
