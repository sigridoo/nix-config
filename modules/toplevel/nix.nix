{
  delib,
  pkgs,
  lib,
  ...
}: let
  nix = {
    package = lib.mkForce pkgs.nixVersions.latest;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      trusted-users = ["root" "@wheel"];
      substituters = [
        # cache mirror located in China
        # status: https://mirrors.ustc.edu.cn/status/
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        # status: https://mirror.sjtu.edu.cn/
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # others
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirrors.sustech.edu.cn/nix-channels/store"
        # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"

        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      builders-use-substitutes = true;
    };
  };
in
  delib.module {
    name = "nix";

    nixos.always = {
      inherit nix;
      # List all packages in /etc/current-system-packages
      environment.etc."current-system-packages".text =
        let
          packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
          sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
          formatted = builtins.concatStringsSep "\n" sortedUnique;
        in
          formatted;
    };
    home.always = {inherit nix;};
  }
