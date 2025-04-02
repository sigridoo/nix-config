{delib, host, shell, ...}:
delib.module {
  name = "programs.nushell";

  options = delib.singleEnableOption builtins.elem "nushell" shell.enabledShells;

  home.ifEnabled.programs.nushell = {
    enable = true;
    # TODO: Add config file
    shellAliases = shell.nuShellAliases;
  };
}
