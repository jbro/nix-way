{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts;
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };
  };
}
