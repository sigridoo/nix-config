{delib, pkgs, ...}:
delib.module {
  name = "programs.languages.nix";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    nil
    statix
    deadnix
    alejandra
  ];
}
