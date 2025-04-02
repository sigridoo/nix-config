{delib, ...}:
delib.module {
  name = "programs.languages.yaml";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    nodePackages.yaml-language-server
  ];
}
