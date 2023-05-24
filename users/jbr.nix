{
  pkgs,
  inputs,
  config,
  lib,
  secrets,
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
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
      NIXOS_OZONE_WL = "1";
    };
  };

  home.packages = with pkgs; [
    ripgrep
    mullvad-vpn
    pavucontrol
    slack
  ];

  fonts.fontconfig.enable = true;

  programs.home-manager.enable = true;

  programs.bash.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        ExtensionSettings = {};
      };
    };
  };

  home.file.".ssh/id_ed25519".source = config.lib.file.mkOutOfStoreSymlink secrets."jbr-ssh/priv".path;
  home.file.".ssh/id_ed25519.pub".source = config.lib.file.mkOutOfStoreSymlink secrets."jbr-ssh/pub".path;

  systemd.user.startServices = "sd-switch";
}
