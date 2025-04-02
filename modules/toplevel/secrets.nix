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
  sopsconfig = {
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
    home.packages = with pkgs; [sops age gnupg];
    imports = [inputs.sops-nix.homeManagerModules.sops];
    sops = sopsconfig // {inherit(cfg) secrets templates;};
  };

  nixos.always = {cfg, myconfig, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = sopsconfig // {inherit(cfg) secrets templates;};
  };

}
