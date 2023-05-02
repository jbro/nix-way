{pkgs, ...}:
pkgs.writeShellApplication rec {
  name = "wrap-sops-key";
  runtimeInputs = with pkgs; [clevis];
  text = ''
    if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    clevis encrypt tpm2 '{}' < "/etc/''${1}.age.key" > "hosts/''${1}/sopskey.enc"
  '';
}
