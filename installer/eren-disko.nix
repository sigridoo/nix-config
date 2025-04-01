{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults" "umask=0077"];
              };
            };
            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "enc";
                extraOpenArgs = [
                  "--allow-discards" # enalbe trim, only for ssd
                  "--perf-no_read_workqueue" # disalbe kernel read/write queue, improve performance
                  "--perf-no_write_workqueue"
                ];
                # use fido2 hardware key to unlock
                # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
                # `sudo -E -s systemd-cryptenroll --fido2-device=auto /dev/nvme0n1p2`
                settings = {crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];};
                content = {
                  type = "btrfs";
                  # set pool label to 'nixos'
                  extraArgs = ["-L" "nixos" "-f"];
                  postCreateHook = ''
                    mount -t btrfs /dev/disk/by-label/nixos /mnt
                    btrfs subvolume snapshot -r /mnt/@ /mnt/@snapshot/@-blank
                    umount /mnt
                  '';
                  subvolumes = {
                    # root volume will erase, so we don't need to compress
                    "@" = {
                      mountpoint = "/";
                      mountOptions = ["subvol=@" "compress=none" "noatime" "discard" "space_cache=v2"];
                    };
                    # store snapshot
                    "@snapshot" = {
                      mountpoint = "/.snapshot";
                      mountOptions = ["subvol=@snapshot" "compress-force=zstd:3" "noatime" "discard" "space_cache=v2"];
                    };
                    # store nix packages
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["subvol=@nix" "compress-force=zstd:1" "noatime" "discard" "space_cache=v2"];
                    };
                    # store impermanence folder or file
                    "@persist" = {
                      mountpoint = "/.persist";
                      mountOptions = ["subvol=@persist" "compress=zstd:1" "noatime" "discard" "space_cache=v2"];
                    };
                    # store log file
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=@log" "compress-force=zstd:1" "noatime" "discard" "space_cache=v2"];
                    };
                    # swap file
                    "@swap" = {
                      mountpoint = "/.swap";
                      mountOptions = ["subvol=@swap" "noatime"];
                      swap.swapfile.size = "32G";
                    };
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
