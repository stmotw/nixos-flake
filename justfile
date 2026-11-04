# Run CI checks, equivalent of .github/workflows/ci.yml
check:
    nix run nixpkgs#alejandra -- --check .
    nix run nixpkgs#deadnix -- --fail .
    nix run nixpkgs#statix -- check .
    find . -name '*.sh' -type f -not -path './.git/*' -exec nix run nixpkgs#shellcheck -- {} +
    nix flake check --no-build
