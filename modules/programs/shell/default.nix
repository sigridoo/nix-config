{delib, host, ...}:
delib.module {
  name = "programs.shell";

  options = let
    allShells = ["bash" "zsh" "nu"];
  in {
    enabledShells = listOfOption (enum allShells) ["bash"];
    bashShellAliases = attrsOfOption str {};
    zshShellAliases = attrsOfOption str {};
    nuShellAliases = attrsOfOption str {};
  }

  myconfig.always = {cfg, ...}: {
    args.shared.shell = cfg;
  }

}
