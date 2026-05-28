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

  { -- breadcrumbs and object tree
    "aerial.nvim",

    event = "DeferredUIEnter",
    after = function()
      local opts = {
        backends    = { "treesitter", "lsp" },
        layout      = { max_width = { 40, 0.2 }, min_width = 25 },
        show_guides = true,
        attach_mode = "window",
        filter_kind = false,
      }

      require("aerial").setup(opts)
      vim.keymap.set("n", "<leader>lS", "<cmd>AerialToggle<cr>", { desc = "Symbol outline" })
    end
  },

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
}
