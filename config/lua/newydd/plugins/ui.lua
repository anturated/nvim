return {

  {
    "mini.icons",

    lazy = false,
    priority = 100,

    -- init = function()
    --   package.preload["nvim-web-devicons"] = function()
    --     require("mini.icons").mock_nvim_web_devicons()
    --     return package.loaded["nvim-web-devicons"]
    --   end
    -- end,
  },

  { "nui.nvim" },

  -- TODO: customize this
  {
    "indent-blankline.nvim",

    event = "DeferredUIEnter",
    after = function()
      require("ibl").setup({
        scope = { enabled = false },
        exclude = {
          filetypes = {
            "alpha",
            "fugitive",
            "help",
            "lazy",
            "NvimTree",
            "ToggleTerm",
            "LazyGit",
            "TelescopePrompt",
            "prompt",
            "code-action-menu-menu",
            "code-action-menu-warning-message",
            "Trouble",
          },
        },
      })
    end,
  },

  {
    "which-key.nvim",

    event = "DeferredUIEnter",
    after = function()
      local opts = {
        preset = "modern",
        delay = vim.o.timeoutlen,
        icons = { mappings = true },
        win = { border = "rounded" },
      }
      require("which-key").setup(opts)
    end,
  },

  {
    "nvim_context_vt",
    after = function()
      require("nvim_context_vt").setup({
        prefix = "=",
      })
    end,
  },

  {
    "fidget.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("fidget").setup({
        notification = {
          window = { normal_hl = "MsgArea", winblend = 100 },
        },
        progress = {
          display = { done_icon = "󰗡" },
          ignore = {
            "null-ls",
          },
        },
        integration = {
          ["nvim-tree"] = { enable = true },
        },
      })
    end,
  },

  { -- used to use brenoprata10/nvim-highlight-colors,
    -- let's see what this one does
    "nvim-colorizer.lua",
    event = "DeferredUIEnter",
    after = function()
      require("colorizer").setup({
        user_default_options = {
          RGB = true,
          RRGGBB = true,
          names = false,
          RRGGBBAA = true,
          AARRGGBB = false,
          rgb_fn = false,
          hsl_fn = false,
          css = false,
          css_fn = false,
          mode = "background",
          tailwind = "both",
          sass = {
            enable = true,
            parsers = { css = true },
          },
          virtualtext = " ",
        },

        buftypes = {
          "*",
          "!dashboard",
          "!lazy",
          "!popup",
          "!prompt",
        },
      })
    end,
  },

  {
    "todo-comments.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("todo-comments").setup()

      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next TODO" })
      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Prev TODO" })
    end,
  },

  -- TODO: figure out if this exists in nixpkgs
  -- highlight all instances of the word under cursor
  -- {
  --   "vim-illuminate",
  --   event = "DeferredUIEnter",
  --
  --   after = function()
  --     local illuminate = require("illuminate")
  --
  --     local opts = {
  --       delay              = 200,
  --       filetypes_denylist = { "neo-tree", "aerial", "help", "TelescopePrompt" },
  --     }
  --
  --     illuminate.configure(opts)
  --
  --     -- honestly why when * and # exists i don't even use this
  --     -- NOTE: i don't use this maybe remove????
  --     vim.keymap.set("n", "]]", function() illuminate.goto_next_reference(false) end, { desc = "Next reference" })
  --     vim.keymap.set("n", "[[", function() illuminate.goto_prev_reference(false) end, { desc = "Prev reference" })
  --   end
  -- },
}
