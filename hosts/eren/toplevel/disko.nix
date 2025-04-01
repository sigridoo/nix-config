{
  delib,
  pkgs,
  lib,
  ...
}:
delib.host {
  name = "eren";

  myconfig.disko = {
    enable = true;

    configuration.devices = {
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
  };

  nixos = {
    # from https://github.com/vimjoyer/impermanent-setup/blob/main/final/configuration.nix
    boot.initrd.postDeviceCommands = lib.mkAfter ''
      # create tmp folder and mount btrfs / volume
      mkdir /btrfs_tmp
      mount -t btrfs /dev/disk/by-label/nixos /btrfs_tmp
      # move root subvolume to 
      if [[ -e /btrfs_tmp/@ ]]; then
          mkdir -p /btrfs_tmp/@snapshot/@-old
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/@ "/btrfs_tmp/@snapshot/@-old/$timestamp"
          echo " >> >> Move old root to /btrfs_tmp/@snapshot/@-old/$timestamp << <<"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
          echo " >> >> $1 Deleted!! << <<"
      }
      # remove subvolume that after 30 day
      for i in $(find /btrfs_tmp/@snapshot/@-old/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/@
      umount /btrfs_tmp
      echo " >> >> Rollback complete << <<"
    '';
    boot.initrd.supportedFilesystems = ["btrfs"];
    # trim disk weekly
    services.fstrim.enable = true;

    fileSystems."/.persist".neededForBoot = true;
    fileSystems."/var/log".neededForBoot = true;

    # hibernate to swap
    # boot = {
    #   kernelParams = [
    #     # the number need to caculate, see https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
    #     # TODO: Caculate the offset
    #     "resume_offset=533760"
    #   ];
    #   resumeDevice = "/dev/disk/by-label/nixos";
    # };
  };
}

