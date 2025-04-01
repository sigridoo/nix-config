# IMPURE
{
  delib,
  homeconfig,
  ylib,
  pkgs,
  ...
}:
delib.module {
  name = "secrets";

  options.sops = with delib; {
    secrets = attrsOfOption attrs {};
    templates = attrsOfOption attrs {};
  };

  myconfig.always.persist.user.files = [".config/sops/age/keys.txt"];

  # templates are not yet implemented in sops-nix for home-manager
  home.always = {cfg, ...}: {
    home.packages = [pkgs.sops];
    imports = [inputs.sops.homeManagerModule];

    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = toString /${homeconfig.home.homeDirectory}/.config/sops/age/keys.txt;
      inherit (cfg) secrets;
    };
  };

}
