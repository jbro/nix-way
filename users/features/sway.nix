{
  lib,
  pkgs,
  ...
}: {
  programs.wofi.enable = true;
  home.packages = with pkgs; [
    brightnessctl
  ];

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
    };
  };
}
