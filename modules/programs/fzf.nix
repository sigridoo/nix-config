{delib, host, ...}:
delib.module {
  name = "programs.fzf";

  options = delib.singleEnableOption host.cliFeatured;

  home.ifEnabled.programs.fzf = {
    enable = true;
    enableBashIntegration = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules --exclude Library";
      defaultOptions = [
        "--info=inline"
        "--height 40%"
        "--layout reverse"
        "--border top"
      ];
      changeDirWidgetCommand = "fd --type d --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules --exclude Library";
      changeDirWidgetOptions = [
        "--walker-skip .git,node_modules,target"
        "--preview 'tree -C {}'"
        "--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
        "--color header:italic"
        "--header 'Press CTRL-Y to copy command into clipboard'"
      ];
      historyWidgetOptions = [
        "--height 20%"
        "--layout default"
        "--border bottom"
      ];
      fileWidgetCommand = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git --exclude node_modules --exclude Library";
      fileWidgetOptions = [
        "--walker-skip .git,node_modules,target"
        "--preview 'bat -n --color=always {}'"
        "--bind 'ctrl-/:change-preview-window(down|hidden|)'"
      ];
  };
}
