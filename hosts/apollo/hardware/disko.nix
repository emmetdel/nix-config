{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = ["-F" "32" "-n" "BOOT"];
              };
            };
            swap = {
              size = "4G";
              type = "8200";
              content = {
                type = "swap";
                randomEncryption = false;
              };
            };
            root = {
              size = "100%";
              type = "8300";
              content = {
                type = "btrfs";
                mountpoint = "/";
                extraArgs = ["-L" "nixos"];
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["noatime" "compress=zstd:3"];
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["noatime" "compress=zstd:3"];
                  };
                  "/var/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["noatime" "compress=zstd:3"];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = ["noatime" "compress=zstd:3"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
