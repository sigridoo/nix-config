{delib, ...}:
delib.module {
  name = "programs.languages.bash";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    nodePackages.bash-language-server
    shellcheck
    shfmt
  ];
}
