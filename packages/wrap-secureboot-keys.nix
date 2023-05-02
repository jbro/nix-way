{pkgs, ...}:
pkgs.writeShellApplication rec {
  name = "wrap-secureboot-keys";
  runtimeInputs = with pkgs; [clevis gnutar];
  text = ''
    if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    tar -c -O -C /etc/ secureboot/  | clevis encrypt tpm2 '{}' > "hosts/''${1}/secureboot-keys.tar.enc"
  '';
}
