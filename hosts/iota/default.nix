{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.gpd-pocket-3

    inputs.disko.nixosModules.disko
    ./disko.nix

    inputs.sops-nix.nixosModules.sops

    inputs.lanzaboote.nixosModules.lanzaboote

    ../../modules/btrfs_swap.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_2;

  boot.bootspec.enable = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.systemd-boot.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  boot.initrd.systemd.enable = true;

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age.keyFile = "/etc/iota.age.key";

    gnupg.sshKeyPaths = [];
    age.sshKeyPaths = [];

    secrets = {
      jbr-password-hash = {
        neededForUsers = true;
      };
    };
  };

  networking.hostName = "iota";

  systemd.network.enable = true;
  systemd.network.networks."lan" = {
    matchConfig.Name = "enp175s0";
    networkConfig.DHCP = "ipv4";
    linkConfig.RequiredForOnline = "no";
  };
  systemd.network.networks."wlan" = {
    matchConfig.Name = "wlan0";
    networkConfig.DHCP = "ipv4";
    linkConfig.RequiredForOnline = "no";
  };
  networking.dhcpcd.enable = false;

  networking.wireless.iwd.enable = true;
  networking.wireless.userControlled.enable = true;

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  time.timeZone = "Europe/Copenhagen";

  services = {
    openssh = {
      enable = true;
      settings = {
        permitRootLogin = "no";
        passwordAuthentication = false;
      };
    };
    nscd.enableNsncd = true;
    btrfs-swapfile.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    rnix-lsp
    elinks
    git
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set number
        colorscheme gruvbox
        set mouse=
      '';
      packages.all = with pkgs.vimPlugins; {
        start = [
          (nvim-treesitter.withPlugins (ps: [ps.nix]))
          nvim-lspconfig
          vim-commentary
          nvim-cmp
          cmp-nvim-lsp
          cmp-buffer
          cmp-nvim-lua
          vim-nix
          gruvbox-nvim
        ];
      };
    };
  };

  security.sudo.extraRules = [
    {
      groups = ["wheel"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  users.mutableUsers = false;

  users.users.jbr = {
    isNormalUser = true;
    description = "Jesper B. Rosenkilde";
    extraGroups = ["wheel" "tss"];
    passwordFile = config.sops.secrets.jbr-password-hash.path;
  };

  system.stateVersion = "22.11";
}
