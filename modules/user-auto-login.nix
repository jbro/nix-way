{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
{

  # systemd.services."autovt@tty1".description = "Autologin at the TTY1";
  # systemd.services."autovt@tty1".after = [ "systemd-logind.service" ];  # without it user session not started and xorg can't be run from this tty
  # systemd.services."autovt@tty1".wantedBy = [ "multi-user.target" ];
  # systemd.services."autovt@tty1".serviceConfig =
  #   { ExecStart = [
  #     ""  # override upstream default with an empty ExecStart
  #     "@${pkgs.utillinux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login --autologin guest --noclear %I $TERM"
  #   ];
  #   Restart = "always";
  #   Type = "idle";
  # };
}
