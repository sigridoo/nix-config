{
  delib,
  inputs,
  homeconfig,
  host,
  ...
}:
delib.module {
  name = "programs.nixvim";

  options.programs.nixvim = with delib; {
    enable = boolOption host.cliFeatured;

    defaultEditor = boolOption true;
  };

  myconfig.always.args.shared.nixvimLib = homeconfig.lib.nixvim;

  home.always.imports = [inputs.nixvim.homeManagerModules.nixvim];

  home.ifEnabled = {cfg, ...}: {
    programs.nixvim = {
      enable = true;
      inherit (cfg) defaultEditor;

      opts = {
        autowrite = true; # Auto write when buffer is hide
        ignorecase = true;
        smartcase = true;
        clipboard = ""; # Set to unamedplus if you want to use systemclipboard
        conceallevel = 0; # Set to 2 if you want to hide conceal text
        cursorline = true; # Highlight on cur line
        formatoptions = "jcroqlnt"; # Format options
        inccommand = "nosplit"; # Preview incremental substitute
        jumpoptions = "view";
        laststatus = 3; # Only one statusline when has multiple window
        list = false; # Don't show invisible charecters(tabs, trail...)
        fillchars = {
          eob = " ";
          fold = " ";
          foldopen = "";
          foldsep = " ";
          foldclose = "";
        };
        mouse = "a"; # Enable mouse support
        number = true; # Show line number
        relativenumber = true; # Relative line number
        pumblend = 10; # Popup blend
        pumheight = 10; # Maxium number of entries in a popup
        # ruler = false; # Disable default ruler
        scrolloff = 8; # Lines below cursor to display
        sidescrolloff = 10; # Columns beside sursor to display
        sessionoptions = [ "buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" "folds" ];
        expandtab = true; # Expand tab to space
        tabstop = 2; # Number of spaces tabs count for
        shiftwidth = 2; # Size of an indent
        softtabstop = 2;
        shiftround = true; # Round indent to multiple of shiftwidth
        smartindent = true;
        # Split
        splitbelow = true;
        splitkeep = "screen";
        splitright = true;
        termguicolors = true; # Enable truecolor
        undofile = true; # Enable undo file
        undolevels = 10000;
        swapfile = false; # Disable swap file
        virtualedit = "block"; # Only allow cursor move to nontestarean when in virtual bloc mode
        wildmode = "longest:full,full"; # Command-line completion mode
        winminwidth = 5; # Minimal window width

        textwidth = 100;
        colorcolumn = "+1"; #Highlight textwidth line

        spell = false; # Disable spell

        foldlevel = 99;
      };

      diagnostics = {
        update_in_insert = true;
      };
    };
  };
}
