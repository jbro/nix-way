{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "DroidSansMono"];};
      name = "JetBrainsMono Nerd Font Mono";
      size = 11;
    };
  };
}
