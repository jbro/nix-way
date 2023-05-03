{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    inputs.nixos-hardware.nixosModules.common-hidpi
  ];
  boot.kernelParams = [
    "fbcon=rotate:1"
    "video=DSI-1:panel_orientation=right_side_up"
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "thunderbolt"];
  boot.kernelModules = ["kvm-intel" "ssd_mod"];

  fonts.fontconfig = {
    subpixel.rgba = "vbgr";
    hinting.enable = lib.mkDefault false;
  };

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
