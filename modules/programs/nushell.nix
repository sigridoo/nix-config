{delib, ...}:
delib.module {
  name = "programs.nushell";

  options.programs.nushell = {
    enable = boolOption false;
    shellAliases = attrsOfOption str {};
  };

  home.ifEnabled.programs.nushell = {
    enable = true;
    inherit (cfg) shellAliases;

    # TODO: Add config file
  };
}
