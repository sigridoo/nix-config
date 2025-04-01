# IMPURE
{
  delib,
  homeconfig,
  pkgs,
  inputs,
  lib,
  ...
}:
delib.module {
  name = "secrets";

  options.secrets = with delib; {
    secrets = attrsOfOption attrs {};
    templates = attrsOfOption attrs {};
  };

  myconfig.always.persist.user.files = [".config/sops/age/keys.txt"];

  # templates are not yet implemented in sops-nix for home-manager
  home.always = {cfg, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = toString /${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt;
      inherit (cfg) secrets;
    };
  };

  nixos.always = {cfg, myconfig, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    system.activationScripts.setupSecrets = lib.mkIf (myconfig.persist.enable && cfg.secrets != {}) {
      deps = [ "persist-files" ];
    };
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = toString /${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt;
      inherit (cfg) secrets;
    };
  };

}
