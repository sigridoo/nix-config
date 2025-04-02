# IMPURE
{
  delib,
  homeconfig,
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    gnupg.sshKeyPaths = [];
    age.sshKeyPaths = [];
    # age.keyFile = toString /.persist/${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt;
    age.keyFile = if config.myconfig.persist.enable
      then
        "/.persist/${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt"
      else
        "/${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt";
  };
in
delib.module {
  name = "secrets";

  options.secrets = with delib; {
    secrets = attrsOfOption attrs {};
    templates = attrsOfOption attrs {};
  };

  myconfig.always.persist.user.files = [".config/sops/age/keys.txt"];

  # templates are not yet implemented in sops-nix for home-manager
  home.always = {cfg, ...}: {
    home.packages = [pkgs.sops];
    imports = [inputs.sops-nix.homeManagerModules.sops];
    sops = sops // {inherit(cfg) secrets;};
  };

  nixos.always = {cfg, myconfig, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = sops // {inherit(cfg) secrets;};
  };

}
