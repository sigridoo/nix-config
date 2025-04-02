{delib, ...}:
delib.module {
  name = "programs.nixvim.plugins.fzf-lua";

  options = delib.singleEnableOption true;

  home.ifEnabled.programs.nixvim.plugins.fzf-lua = {
    enable = true;
    profile = "ivy";

    keymaps = {
      "<leader>/" = "live_grep_native";
      "<leader><space>" = "files";
      "<leader>." = "resume";
      "<leader>," = "lgrep_curbuf";
      "<leader>:" = "command_history";
      "<leader>ff" = "files";
      "<leader>fr" = "oldfiles";
      "<leader>fw" = "grep_cword";
      "<leader>fv" = "grep_visual";
      "<leader>fg" = "git_files";
      "<leader>fb" = "buffers";
      "<leader>fz" = "zoxide";
      # Git
      "<leader>gs" = "git_status";
      "<leader>gt" = "git_stash";
      "<leader>gc" = "git_commits";
      "<leader>gC" = "git_bcommits";
      "<leader>gb" = "git_branches";
      "<leader>gB" = "git_blame";
      # vim self related
      "<leader>f\"" = "registers";
      "<leader>fa" = "autocmds";
      "<leader>fc" = "commands";
      "<leader>fd" = "diagnostics_document";
      "<leader>fD" = "diagnostics_workspace";
      "<leader>fh" = "helptags";
      "<leader>fH" = "highlights";
      "<leader>fj" = "jumps";
      "<leader>fk" = "keymaps";
      "<leader>fl" = "loclist";
      "<leader>fL" = "loclist_stack";
      "<leader>fq" = "quickfix";
      "<leader>fQ" = "quickfix_stack";
      "<leader>fm" = "marks";
      "<leader>fM" = "manpages";
    };
  };
}
