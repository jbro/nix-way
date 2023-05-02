{
  pkgs,
  self,
  ...
}:
pkgs.writeShellApplication rec {
  name = "unwrap-sops-key";
  runtimeInputs = with pkgs; [clevis];
  text = ''
    if [ $# -lt 1 ]; then
      echo "Usage: nix run .#${name} <hostname>"
      exit 1
    fi

    clevis decrypt tpm2 '{}' > "''${1}.age.key" < "${self}/hosts/''${1}/sopskey.enc"
  '';
}
