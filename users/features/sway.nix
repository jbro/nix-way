{...}: {
  imports = [
    ./wofi.nix
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
}

