{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

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

  programs.firefox.enable = true;

  programs.wofi.enable = true;

  home.packages = with pkgs; [
    ripgrep
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        {command = "firefox";}
      ];
      output = {
        "DSI-1" = {
          scale = "1.5";
          transform = "90";
        };
      };
    };
  };

  systemd.user.startServices = "sd-switch";
}
