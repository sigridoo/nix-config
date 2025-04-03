{ delib, ...}:
delib.module {
  name = "programs.nixvim";
  home.ifEnabled.programs.nixvim = {
    globals.mapleader = " ";
  };
}
