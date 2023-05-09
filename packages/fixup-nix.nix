{pkgs, ...}:
pkgs.writeShellApplication rec {
  name = "fixup-nix";
  runtimeInputs = with pkgs; [alejandra statix];
  text = ''
    echo "Checking with statix..."
    statix check  2>/dev/null \
      || (echo "Fixing with statix..." && statix fix)

    echo "Formating with alejandra..."
    alejandra -qq .
  '';
}
