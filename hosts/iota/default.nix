{
  config,
  pkgs,
  lib,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.nixos-hardware.nixosModules.common-hidpi

    inputs.disko.nixosModules.disko
    ./disko.nix

    inputs.sops-nix.nixosModules.sops

    inputs.lanzaboote.nixosModules.lanzaboote

    inputs.home-manager.nixosModules.home-manager
  ];

  boot.kernelParams = [
    "fbcon=rotate:1"
    "video=DSI-1:panel_orientation=right_side_up"
    "quiet"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "thunderbolt" "i915"];
  boot.initrd.kernelModules = ["i915"];
  boot.kernelModules = ["kvm-intel" "ssd_mod"];

  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  fonts.fontconfig = {
    subpixel.rgba = "vbgr";
    hinting.enable = lib.mkDefault false;
  };

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters = [
    "https://nix-community.cachix.org"
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_3;

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
      "jbr-ssh/pub" = {
        owner = "jbr";
        group = "users";
        mode = "600";
      };
      "jbr-ssh/priv" = {
        owner = "jbr";
        group = "users";
        mode = "600";
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

  security.polkit.enable = true;
  security.rtkit.enable = true;

  time.timeZone = "Europe/Copenhagen";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  hardware.sensor.iio.enable = true;
  services.udev.extraHwdb = ''
    sensor:modalias:*
      ACCEL_MOUNT_MATRIX=-0, -1, 0; -1, 0, 0; 0, 0, 1
  '';

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        PasswordAuthentication = lib.mkDefault false;
      };
    };
    nscd.enableNsncd = true;
    mullvad-vpn.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    kanata = {
      enable = true;
      keyboards."iota-internal" = {
        devices = ["/dev/input/by-id/usb-HAILUCK_CO._LTD_USB_KEYBOARD-event-kbd"];
        config = ''
          (defsrc caps lmeta)
          (defalias che (tap-hold 200 200 esc lmeta))
          (deflayer default
            @che menu)
        '';
      };
    };
  };

  programs.git.enable = true;

  nixpkgs.config.allowUnfree = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = let inherit (config.sops) secrets; in {inherit secrets;};
  home-manager.users.jbr = {
    imports = ["${inputs.self}/users/jbr.nix"];
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

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  users.mutableUsers = false;
  programs.zsh.enable = true;

  users.users.jbr = {
    isNormalUser = true;
    description = "Jesper B. Rosenkilde";
    extraGroups = ["wheel" "tss" "dialout"];
    passwordFile = config.sops.secrets.jbr-password-hash.path;
    shell = pkgs.zsh;
  };

  system.stateVersion = "22.11";
}
