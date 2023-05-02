{
  pkgs,
  self,
  ...
}:
pkgs.writeShellApplication rec {
  name = "unwrap-secureboot-keys";
  runtimeInputs = with pkgs; [clevis gnutar];
  text = ''
    if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    clevis decrypt tpm2 '{}' < "${self}/hosts/''${1}/secureboot-keys.tar.enc" | tar -x
  '';
}
