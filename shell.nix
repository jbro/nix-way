{
  inputs,
  pkgs,
  ...
}
: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
    shellHook = ''
      export SOPS_AGE_KEY_FILE="/etc/''${HOSTNAME}.age.key"
    '';
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git

      sops
      age

      tpm2-tools
      clevis

      nixos-generators

      sbctl
    ];
  };
}
