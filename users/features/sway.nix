{
  lib,
  pkgs,
  ...
}: {
  programs.wofi.enable = true;
  home.packages = with pkgs; [
    brightnessctl
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 32;
  };

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      keybindings = lib.mkOptionDefault {
        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 10%-";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s +10%";
        "${modifier}+Left" = "workspace prev";
        "${modifier}+Right" = "workspace next";
      };
      output = {
        "DSI-1" = {
          scale = "1.5";
          transform = "90";
        };
      };
      input = {
        "10182:275:GXTP7380:00_27C6:0113_Stylus" = {
          "calibration_matrix" = "0 1 0 -1 0 1";
        };
        "10182:275:GXTP7380:00_27C6:0113" = {
          "calibration_matrix" = "0 1 0 -1 0 1";
        };
        "1:1:kanata" = {
          "xkb_options" = "compose:menu";
        };
      };
    };
  };
}
