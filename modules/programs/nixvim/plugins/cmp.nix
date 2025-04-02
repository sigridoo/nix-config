{delib, nixvimLib, ...}:
delib.module {
  name = "programs.nixvim.plugins.cmp";

  options = delib.singleEnableOption true;
  home.ifEnabled.programs.nixvim.keymaps = [
    # For luasnip
    {
      mode = ["i" "s"];
      key = "<C-j>";
      action = nixvimLib.mkRaw ''
        local ls = require("luasnip")
        function()
          if ls.choice_active() then
            ls.change_choice(1)
          end
        end
      '';
      options = {
        expr = true;
        silent = true;
        desc = "Toggle luasnip choices";
      };
    }
    {
      mode = ["i" "s"];
      key = "<C-l>";
      action = nixvimLib.mkRaw ''
        function() require("luasnip").jump( 1) end
      '';
      options = {
        expr = true;
        silent = true;
        desc = "Jump to next in snippet";
      };
    }
    {
      mode = ["i" "s"];
      key = "<C-h>";
      action = nixvimLib.mkRaw ''
        function() require("luasnip").jump(-1) end
      '';
      options = {
        expr = true;
        silent = true;
        desc = "Jump to previous in snippet";
      };
    }
  ];

  home.ifEnabled.programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          ghost_text.enabled = true;
          list.selection = {
            auto_insert = false;
            preselect = true;
          };
          menu = {
            auto_show = false;
            draw.treesitter = {lsp = true;};
          };
        };
        signature = {
          enabled = true;
        };
        sources = {
          default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
          ];
          provider = {
            buffer.score_offset = -7;
          };
        };
        keymap = {
          preset = "super-tab";
          # Disable Ctrol+b/f to scroll documentation
          "<C-f>" = [];
          "<C-b>" = [];
          "<C-u>" = [
            "scroll_documentation_up"
            "fallback"
          ];
          "<C-d>" = [
            "scroll_documentation_down"
            "fallback"
          ];
        };
        snippet = {
          active = nixvimLib.mkRaw ''
            function(filter)
              local ls = require('luasnip')
              if is_hidden_snippet() then return true end
              if filter and filter.direction then return ls.jumpable(filter.direction) end
              return ls.in_snippet()
            end
          '';
          jump = nixvimLib.mkRaw ''
            function(direction)
              local ls = require('luasnip')
              if is_hidden_snippet() then return ls.expand_or_jump() end
              return ls.jumpable(direction) and ls.jump(direction)
            end
          '';
          expand = nixvimLib.mkRaw ''
            function(snippet) require('luasnip').lsp_expand(snippet) end
          '';
        };
      };
    };

    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = false;
        exit_roots = false;
        keep_roots = true;
        link_roots = true;
        update_events = [
          "TextChanged"
          "TextChangedI"
        ];
      };
    };
  };
}
