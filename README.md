# This is the way

to nixvana ...

## Install

### Create an install USB

Create a NixOS install iso:

    $ nix build github:jbro/nix-way#generate-install-iso

### iota (GPD Pocket 3)

Boot the intall iso.

Partion the internal drive with [disko](https://github.com/nix-community/disko) (optional, **will wipe all drives**):

    $ nix run github:jbro/nix-way#format-disks iota

Mount volumes:

    $ nix run github:jbro/nix-way#mount-disks iota
    
Install NixOS:

    $ nix run github:jbro/nix-way#install iota
    
## TODO

### NixOS

- test vm in flake
- binary caches
- Investigate overlay to only build the nerd fonts that I use
- Get btrfs based ephemereal root working
    - https://discourse.nixos.org/t/impermanence-vs-systemd-initrd-w-tpm-unlocking/25167/2
- Get btrfs subvolume persistence working for directories
    - Get `cp --reflink=always` persistence working for files

### Iota

- Homemanager
    - Look at stylix
    - port zsh
    - port vimrc ?
- Plymouth
- Disable sshd

## Resources

[hMasur's dotfiles](https://github.com/nmasur/dotfiles)

[Misterio77's nixos flake templates](https://github.com/Misterio77/nix-starter-configs)

[Misterio77's nix config](https://github.com/Misterio77/nix-config)
