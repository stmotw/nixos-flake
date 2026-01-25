# NixOS

My Nix flake ❄

## Structure

```plaintext
├── hosts/              # Defines host configs using data from secrets.nix
│   ├── arvad/          # WSL NixOS machine
│   ├── fiddlebender/   # Oracle Cloud VM
│   └── ai71mac/        # 2024 11 MacBook Pro M4
├── lib/                # Custom lib functions
├── modules/            # Host-independent implementation of available modules
│   ├── darwin/         # Darwin configurations
│   ├── home/           # home-manager configurations
│   ├── nixos/          # NixOS configurations
│   ├── shared/         # Shared darwin, nixos and wsl configurations
│   └── wsl/            # WSL configurations
├── overlays/           # Overlay configurations
├── flake.nix           # 
├── flake.lock
├── secrets.example.nix # Dummy personal information, following secrets.nix
└── secrets.nix         # User's personal information
```

## Config

Modules are enabled by options in `hosts/<host>/configuration.nix`. Modules define options but never read `secrets.nix` directly - hosts pass secrets via options.

`config.mine.<category>.<...>.<option>.enable` is defined in
`modules/[darwin|nixos|shared|wsl]/<category>/<...>/<option>/default.nix`.

`config.mine.home-manager.<category>.<...>.<option>.enable` is defined in
`modules/home/<category>/<...>/<option>/default.nix`.

## Secrets

TBD

## Extending the lib

```plaintext
lib/
├── imports/    # submodule with import-related functions
├── options/    # submodule with option-related functions
└── default.nix # re-exports all submodules as namespaces
```

All lib extensions are overlaid on top of `lib` in `flake.nix`:

```nix
lib = nixpkgs.lib.extend (final: prev: {
  mine = import ./lib {lib = final;};
});
```

They are available in other modules as `lib.mine.<submodule>.<function>`.

## Inspiration

- <https://github.com/mmskv/dotfiles>
- <https://github.com/GregHilston/toolbox/tree/master/nixos>
- <https://github.com/elliottminns/dotfiles/tree/main/nix>
- <https://github.com/thursdaddy/nixos-config/>
