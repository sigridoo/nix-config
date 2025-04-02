{delib, host, shell, ...}:
delib.module {
  name = "programs.bash";

  options = delib.singleEnableOption builtins.elem "bash" shell.enabledShells;

  home.ifEnabled.programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = host.bashShellAliases;
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
