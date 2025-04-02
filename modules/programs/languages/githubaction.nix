{delib, pkgs, ...}:
delib.module {
  name = "programs.languages.githubaction";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    actionlint
  ];
}
