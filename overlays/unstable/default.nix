{inputs, ...}: let
  unstablePkgs = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = "${prev.system}";
      config.allowUnfree = true;
    };
  };
in {
  nixpkgs.overlays = [unstablePkgs];
}
