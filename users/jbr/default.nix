{
  config,
  pkgs,
  ...
}: {
  imports = [];

  home = {
    username = "jbr";
    homeDirectory = "/home/jbr";
    stateVersion = "22.11";
  };

  programs.git = {
    enable = true;
    userName = "Jesper B. Rosenkilde";
    userEmail = "jbr@humppa.dk";
  };

  home.packages = with pkgs; [
    ripgrep
  ];

  programs.home-manager.enable = true;

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

  systemd.user.startServices = "sd-switch";
}
