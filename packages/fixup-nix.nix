{pkgs, ...}:
pkgs.writeShellApplication rec {
  name = "fixup-nix";
  runtimeInputs = with pkgs; [alejandra statix];
  text = ''
    echo "Running statix..."
    statix check || true
    statix fix

    echo "Running alejandra..."
    alejandra .
  '';
}
