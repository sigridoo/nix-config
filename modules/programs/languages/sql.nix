{delib, ...}:
delib.module {
  name = "programs.languages.sql";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    sqlfluff
  ];
}
