{
  delib,
  pkgs,
  homeconfig,
  host,
  ...
}:
delib.module {
  name = "programs.nh";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled = {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "${homeconfig.home.homeDirectory}/nix-config";
    };
  };
}
