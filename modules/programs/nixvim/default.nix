{ delib, inputs, host, ... }:
delib.module {
  name = "programs.nixvim";

  options.programs.nixvim = with delib; {
    enable = boolOption host.cliFeatured;

    defaultEditor = boolOption true;
  };

  home.always.imports = [inputs.nixvim.homeManagerModules.nixvim];

  home.ifEnabled = {cfg, ...}: {
    programs.nixvim = {
      enable = true;
      inherit (cfg) defaultEditor;

      diagnostics = {
        update_in_insert = true;
      };
    };
  };
}
