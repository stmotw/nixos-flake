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

## Module design

Home-manager config is written from system-level modules, and values reach them only through typed
`mine.*` options:

1. A module in `modules/home/` declares the options it needs and writes into
   `home-manager.users.${user.username}`.
2. The host file sets those options, reading `secrets.nix` directly or through `lib.mine.configs`
   helpers.
3. Modules read `config.mine.*` and `pkgs.unstable`. They never take `sec` as an argument, and
   `extraSpecialArgs` is not used.

### Compared to mmskv/dotfiles

[mmskv/dotfiles](https://github.com/mmskv/dotfiles) uses standalone home-manager modules
(`home/*.nix`) that receive `sec`, `inputs` and `pkgs-unstable` through `extraSpecialArgs`
and read secrets directly (e.g. `user = sec.user;` in `home/minimal/git.nix`). A per-user entry
file imports a profile (`minimal`, `desktop`, `mac`).

| | This flake: system modules + `mine.*` options | mmskv: standalone modules + `extraSpecialArgs` |
| --- | --- | --- |
| Per-host choices | One switchboard per host in `hosts/<name>/configuration.nix` | Spread over profile imports and conditionals |
| Secrets | Read only in host files | Any home module can read any field of `sec` |
| Bad or missing value | Fails at the typed option | Fails deep inside the module that uses it |
| System and home coordination | Modules read each other's switches (Dock apps, zsh hooks) | Limited to `osConfig`, none when standalone |
| Unstable packages | `pkgs.unstable` overlay, `system` handled for you | `pkgs-unstable` imported by hand per system |
| Boilerplate | ~15-line skeleton per module, even for one package | A few lines per module |
| Standalone `home-manager switch` | Not possible; needs NixOS or nix-darwin | Works on any machine with Nix |
| Users per host | One (`config.mine.user`) | Several, each with its own profile |

This flake's approach fits its hosts: all are NixOS or nix-darwin, with one user each.
Consider mmskv-style standalone modules if a host can only run standalone home-manager
(no admin rights, not NixOS), or needs a second user with a different profile.

## Inspiration

- <https://github.com/mmskv/dotfiles>
- <https://github.com/GregHilston/toolbox/tree/master/nixos>
- <https://github.com/elliottminns/dotfiles/tree/main/nix>
- <https://github.com/thursdaddy/nixos-config/>
