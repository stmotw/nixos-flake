# NixOS

My Nix flake ❄

## Structure

```plaintext
├── hosts/
│   ├── arvad/        # WSL nixos
│   ├── fiddlebender/ # Oracle Cloud VM
│   └── work-mac/     # 2024 11 MacBook Pro M4
├── lib/              # custom lib functions
├── modules/
│   ├── darwin/       # darwin configurations
│   ├── home/         # home-manager configurations
│   ├── nixos/        # nixos configurations
│   ├── shared/       # shared darwin, nixos and wsl configurations
│   └── wsl/          # wsl configurations
├── overlays/         # overlay configurations
├── flake.nix
└── flake.lock
```

## Config

Modules are enabled by options in `hosts/<host>/configuration.nix`.

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
