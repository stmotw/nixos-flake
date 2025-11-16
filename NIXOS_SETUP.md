# Nixos Setup

How to setup NixOS on different environments.

---

## Initial Setup

### Oracle Cloud VM Setup

NixOS on free Oracle Cloud VM: <https://mtlynch.io/notes/nix-oracle-cloud/>.

#### Warnings

Got these warnings after `nixos-install --no-root-password` in step 9:

```plaintext
⚠️ Mount point '/boot' which backs the random seed file is world accessible, which is a security hole! ⚠️
⚠️ Random seed file '/boot/loader/.#bootctlrandom-seed3a65742456caa856' is world accessible, which is a security hole! ⚠️
```

Fixed by adding `mountOptions` with proper privileges to `disk-config.nix`:

```nix
content = {
  type = "filesystem";
  format = "vfat";
  mountpoint = "/boot";
  mountOptions = [
    "fmask=0077"
    "dmask=0077"
    "defaults"
  ];
};
```

### WSL Setup

NixOS-WSL: <https://github.com/nix-community/NixOS-WSL>

#### Changing default user

Setting `wsl.defaultUser` is insufficient if you don't want to rebuild tarball.
See <https://nix-community.github.io/NixOS-WSL/how-to/change-username.html>.

#### Remote VSCode server

<https://nix-community.github.io/NixOS-WSL/how-to/vscode.html>

### MacOS Setup

Prerequisites: <https://github.com/nix-darwin/nix-darwin?tab=readme-ov-file#prerequisites>

Use vanilla nix from determinate:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

When prompted

```plaintext
Determinate Nix is tested and ready for macOS Tahoe when you are. Selecting ‘no’ will install Nix from NixOS.

Proceed? ([Y]es/[n]o/[e]xplain):
```

Select `no` to install vanilla nix. Otherwise you'll need to add `nix.enable = false;` in your flake, see prerequisites link.

---

## Updates

### Updating the flake

regenerate `flake.lock`:

```bash
nix flake update
```

### Update Oracle Cloud VM

From Oracle Cloud VM:

```bash
sudo nixos-rebuild switch --flake .#fiddlebender
nixos-rebuild list-generations
```

### Update WSL

From WSL nixos:

```bash
sudo nixos-rebuild switch --flake .#arvad
nixos-rebuild list-generations
```

### Update MacOS

From MacOS console:

```bash
sudo darwin-rebuild switch --flake .#work-mac
sudo darwin-rebuild --list-generations
```

## Garbage collection

```bash
nix-collect-garbage --delete-old
sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 1d
nix-env --delete-generations 1d
```

---

## Yubikey

### Managing keys on Windows

[gpg4win](https://www.gpg4win.org/)

### Passing keys to WSL

<https://lgug2z.com/articles/yubikey-passthrough-on-wsl2-with-full-fido2-support/>
