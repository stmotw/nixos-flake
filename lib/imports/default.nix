# Credit: @infinisil
# https://github.com/Infinisil/system/blob/df9232c4b6cec57874e531c350157c37863b91a0/config/new-modules/default.nix
{lib}: let
  getDir = dir:
    lib.mapAttrs (file: type:
      if type == "directory"
      then getDir "${dir}/${file}"
      else type) (
      builtins.readDir dir
    );

  files = dir:
    lib.collect lib.isString (
      lib.mapAttrsRecursive (path: type: lib.concatStringsSep "/" path) (getDir dir)
    );
in {
  ## Recursively list all `default.nix` files in directory
  ##
  ## ```nix
  ## getDefaultNix ./.
  ## ```
  getDefaultNix = dir:
    builtins.map (file: dir + "/${file}") (
      builtins.filter (file: builtins.baseNameOf file == "default.nix") (files dir)
    );
}
