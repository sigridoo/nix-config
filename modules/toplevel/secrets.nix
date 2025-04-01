# IMPURE
{
  delib,
  homeconfig,
  pkgs,
  inputs,
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

  nixos.always = {cfg, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = toString /${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt;
      inherit (cfg) secrets;
    };
  };

}
