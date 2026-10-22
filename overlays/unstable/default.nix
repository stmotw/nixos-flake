{inputs, ...}: let
  unstablePkgs = _final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = prev.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
in {
  nixpkgs.overlays = [unstablePkgs];
}
