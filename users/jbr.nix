{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./features/git.nix
    ./features/kitty.nix
    ./features/neovim.nix
    ./features/sway.nix
    ./features/zsh.nix
  ];

  home = {
    username = "jbr";
    homeDirectory = "/home/jbr";
    stateVersion = "22.11";
    sessionVariables = {
      LIBSEAT_BACKEND = "logind";
    };
  };

  home.packages = with pkgs; [
    ripgrep
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  programs.bash.enable = true;
  programs.firefox.enable = true;

  systemd.user.startServices = "sd-switch";
}
