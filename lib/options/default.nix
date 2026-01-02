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
