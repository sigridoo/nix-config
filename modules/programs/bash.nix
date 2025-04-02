{delib, host, ...}:
delib.module {
  name = "programs.bash";

  options.programs.bash = with delib; {
    enable = boolOption host.cliFeatured;
    shellAliases = attrsOfOption str {};
  };

  home.ifEnabled = {cfg, ...}: {
    programs.bash = {
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
  };
}
