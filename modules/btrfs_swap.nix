# TODO
# Clean up swapfile on service disable
#    - swapoff and rm
# Configure path to swapfile
#    - Don't forget to think about after which mount
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.btrfs-swapfile;
in {
  config = mkIf cfg.enable {
    systemd.services.btrfs-swapfile = {
      description = "Create swapfile it not pressent";
      wantedBy = [
        "multi-user.target"
      ];
      after = [
        "-.mount"
      ];
      before = [
        "swapfile.swap"
      ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "-${pkgs.btrfs-progs}/bin/btrfs filesystem mkswapfile --size ${cfg.size} /swapfile";
      };
    };

    swapDevices = [{device = "/swapfile";}];
  };

  options.services.btrfs-swapfile = {
    enable = mkEnableOption "Btrfs swapfile";
    size = mkOption {
      type = types.str;
      default = "16G";
    };
  };
}
