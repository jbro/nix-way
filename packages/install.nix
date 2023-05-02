{
  pkgs,
  self,
  ...
}:
pkgs.writeShellApplication rec {
  name = "install";
  text = ''
    if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    "${self.packages.${pkgs.system}.unwrap-sops-key}/bin/unwrap-sops-key" "''${1}"
    mkdir -p /mnt/etc/
    mv "''${1}.age.key" /mnt/etc/

    "${self.packages.${pkgs.system}.unwrap-secureboot-keys}/bin/unwrap-secureboot-keys" "''${1}"
    mv secureboot/ /mnt/etc/

    nixos-install --no-root-password --flake "${self}#''${1}"
  '';
}
