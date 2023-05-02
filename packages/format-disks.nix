{
  pkgs,
  self,
  inputs,
  ...
}:
pkgs.writeShellApplication rec {
  name = "format-disks";
  runtimeInputs = [self inputs.disko.packages."${pkgs.system}".disko];

  text = ''
     if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    echo "This will wipe all drives configured with disko!"
    read -p "Are you sure [N/y]? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
      exit 1
    fi

    disko -m create -f "path:${self}#''${1}"
  '';
}
