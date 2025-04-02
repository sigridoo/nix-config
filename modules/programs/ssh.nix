{
  delib,
  pkgs,
  ...
}:
delib.module {
  name = "programs.ssh";

  options = delib.singleEnableOption true;

  myconfig.ifEnabled.persist.user.directories = [".ssh"];

  home.ifEnabled.programs.ssh = {
    enable = true;
    package = pkgs.openssh_hpn;
    compression = true;
  };

  nixos.ifEnabled.programs.ssh = {
    startAgent = true;
  };
}
