{delib, ...}:
delib.module {
  name = "programs.nushell";

  options.programs.nushell = with delib; {
    enable = boolOption false;
    shellAliases = attrsOfOption str {};
  };

  home.ifEnabled = {cfg, ...}: {
    program.nushell = {
      enable = true;
      inherit (cfg) shellAliases;

      # TODO: Add config file
    };
  };
}
