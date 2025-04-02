{delib, ...}:
delib.module {
  name = "programs.languages.lua";

  options = delib.singleEnableOption true;

  home.ifEnabled.home.packages = with pkgs; [
    stylua
    lua-language-server
  ];
}
