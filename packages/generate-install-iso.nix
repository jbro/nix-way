{
  pkgs,
  inputs,
  ...
}: {
  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_3;

  networking.wireless.enable = false;
  networking.wireless.iwd.enable = true;
  networking.wireless.userControlled.enable = true;

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  environment.systemPackages = with pkgs; [
    git
    tpm2-tools
    clevis
    sops
    age
    inputs.disko
  ];
}
