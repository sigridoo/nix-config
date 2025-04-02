{delib, host, ...}:
delib.module {
  name = "programs.bash";

  options.programs.bash = {
    enable = boolOption host.cliFeatured;
    shellAliases = attrsOfOption str {};
  };

  home.ifEnabled.programs.bash = {cfg, ...}: {
    inherit (cfg) shellAliases;
    enable = true;
    enableCompletion = true;
    historyIgnore = [
      "ls"
      "cd"
      "exit"
    ];
    bashrcExtra = ''
      bind -x '"\C-p": __fzf_history__'
    '';
  };
}
