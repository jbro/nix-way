{
  pkgs,
  self,
  inputs,
  ...
}:
pkgs.writeShellApplication rec {
  name = "mount-disks";
  runtimeInputs = [self inputs.disko.packages."${pkgs.system}".disko];

  text = ''
    if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    disko -m mount -f "path:${self}#''${1}"
  '';
}
