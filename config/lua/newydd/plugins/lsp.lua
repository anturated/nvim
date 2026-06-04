return {
  -- json/yaml schemas
  { "SchemaStore.nvim" },

  {
    "nvim-lint",
    event = "DeferredUIEnter",
    after = function()
      require("lint").linters_by_ft = {
        nix = { "nix", "statix", "deadnix" },
        lua = { "selene" },
        markdown = { "proselint" },
        tex = { "proselint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        yaml = { "yamllint" },
      }
    end,
  },

  { "nvim-navic" },

  -- guess indent
  { "vim-sleuth" },

  -- snippets loader
  -- {
  --   "luasnip",
  --   event = "DeferredUIEnter",
  --   after = function()
  --     local ls = require("luasnip")
  --
  --     -- load vscode snippets
  --     require("luasnip.loaders.from_vscode").lazy_load()
  --
  --     -- leave snippet on NORMAL mode
  --     vim.api.nvim_create_autocmd("ModeChanged", {
  --       pattern = { "s:n", "i:n" },
  --       callback = function()
  --         local buf = vim.api.nvim_get_current_buf()
  --         if ls.session.current_nodes[buf] and not ls.session.jump_active then
  --           ls.unlink_current()
  --         end
  --       end,
  --     })
  --   end,
  -- },

  -- snippets collection
  { "friendly-snippets" },
  { -- formatters
    "conform.nvim",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },

        formatters_by_ft = {
          -- keep-sorted start
          bash = { "shfmt" },
          lua = { "stylua" },
          nix = { "nixfmt" },
          sh = { "shfmt" },
          toml = { "taplo" },
          -- keep-sorted end
        },
      }

      require("conform").setup(opts)
    end,
  },
}
