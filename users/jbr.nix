{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./features/bash.nix
    ./features/firefox.nix
    ./features/git.nix
    ./features/home-manager.nix
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

  systemd.user.startServices = "sd-switch";
}
