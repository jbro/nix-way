{
  pkgs,
  self,
  inputs,
  ...
}: {
  generate-install-iso = inputs.nixos-generators.nixosGenerate {
    inherit (pkgs) system;
    specialArgs = {inherit pkgs inputs;};
    modules = [./generate-install-iso.nix];
    format = "install-iso";
  };

  format-disks = import ./format-disks.nix {inherit pkgs self inputs;};
  mount-disks = import ./mount-disks.nix {inherit pkgs self inputs;};
  install = import ./install.nix {inherit pkgs self;};
  wrap-sops-key = import ./wrap-sops-key.nix {inherit pkgs;};
  unwrap-sops-key = import ./unwrap-sops-key.nix {inherit pkgs self;};
  wrap-secureboot-keys = import ./wrap-secureboot-keys.nix {inherit pkgs;};
  unwrap-secureboot-keys = import ./unwrap-secureboot-keys.nix {inherit pkgs self;};
  fixup-nix = import ./fixup-nix.nix {inherit pkgs;};
}
