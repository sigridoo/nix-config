{delib, pkgs, ...}:
delib.module {
  name = "programs.languages.toml";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    taplo
  ];
}
