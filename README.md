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

Secrets are managed via [git-crypt](https://github.com/AGWA/git-crypt), which provides transparent encryption of files in a git repository.

1. `secrets.nix` contains all sensitive configuration (emails, signing keys, user aliases, etc.)
2. The file is encrypted at rest in the repository via git-crypt (see `.gitattributes`)
3. On clone, the file appears as encrypted binary data
4. After unlocking with `git-crypt unlock`, the file is transparently decrypted

### Cloning my setup

```bash
# Initialize your own git-crypt key
rm secrets.nix
git-crypt init

cp secrets.example.nix secrets.nix
# Edit secrets.nix with your values
```

### CI

CI uses `secrets.example.nix` as a mock to evaluate the flake without the git-crypt key.

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
