{
  description = "My NixOS setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ssh-keys = {
      url = "https://github.com/stmotw.keys";
      flake = false;
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    self,
    ...
  } @ inputs: let
    # Import custom lib functions under lib.mine
    lib = nixpkgs.lib.extend (final: prev: {
      mine = import ./lib {lib = final;};
    });

    # See README.md#Secrets
    sec = import ./secrets.nix;

    hosts = {
      arvad = "x86_64-linux";
      fiddlebender = "aarch64-linux";
      work-mac = "aarch64-darwin";
    };

    mkHostConfigurations = {
      predicate,
      systemBuilder,
    }:
      lib.mapAttrs (hostname: system:
        systemBuilder {
          inherit system;
          specialArgs = {inherit inputs lib hostname sec;};
          modules = [./hosts/${hostname}/configuration.nix];
        })
      (lib.filterAttrs (_: predicate) hosts);
  in {
    nixosConfigurations = mkHostConfigurations {
      predicate = lib.hasSuffix "linux";
      systemBuilder = lib.nixosSystem;
    };

    darwinConfigurations = mkHostConfigurations {
      predicate = lib.hasSuffix "darwin";
      systemBuilder = nix-darwin.lib.darwinSystem;
    };
  };
}
