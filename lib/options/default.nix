# Credit: @thursdaddy
# https://github.com/thursdaddy/nixos-config/blob/556d74ca6e3a1043b67832ecde71f3987a91ba09/lib/default.nix
{lib}: {
  ## Create a NixOS module option with no default
  ##
  ## ```nix
  ## mkOpt types.path "Description of my option"
  ## ```
  ##
  #@ Type -> String
  mkOpt = type: description: lib.mkOption {inherit type description;};

  enabled = {
    ## Quickly enable an option.
    ##
    ## ```nix
    ## services.nginx = enabled;
    ## ```
    ##
    #@ true
    enable = true;
  };

  disabled = {
    ## Quickly disable an option.
    ##
    ## ```nix
    ## services.nginx = disabled;
    ## ```
    ##
    #@ false
    enable = false;
  };
}
