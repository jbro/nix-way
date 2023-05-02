{...}: let
  efi-part-end = "513MiB";
in {
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "EFI";
              end = efi-part-end;
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/efi";
              };
            }
            {
              name = "encrypted-system";
              start = efi-part-end;
              content = {
                type = "luks";
                name = "system";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "@" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "discard=async"];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "discard=async"];
                    };
                  };
                };
              };
            }
          ];
        };
      };
    };
  };
}
