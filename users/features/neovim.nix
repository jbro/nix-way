{pkgs, ...}: {
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
}
