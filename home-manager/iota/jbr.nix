{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.hyprland.homeManagerModules.default];

  home = {
    username = "jbr";
    homeDirectory = "/home/jbr";
    stateVersion = "22.11";
    sessionVariables = {
      LIBSEAT_BACKEND = "logind";
    };
  };

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Jesper B. Rosenkilde";
    userEmail = "jbr@humppa.dk";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-commentary
      vim-nix
      gruvbox-nvim
      vim-sandwich
    ];
    extraConfig = ''
      set number
      colorscheme gruvbox
      set mouse=
    '';
    extraPackages = with pkgs; [
      # rnix-lsp
    ];
  };

  programs.kitty.enable = true;

  programs.bash.enable = true;

  home.packages = with pkgs; [
    ripgrep
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    recommendedEnvironment = true;
    systemdIntegration = true;
    extraConfig = import ./hyprland-config.nix {};
  };

  systemd.user.startServices = "sd-switch";
}
