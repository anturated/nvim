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

  -- breadcrumbs
  { "nvim-navic" },

  -- guess indent
  { "vim-sleuth" },

  -- roslyn toolkit
  {
    "roslyn.nvim",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        filewatching = "off", -- FIXME: it watches the entire nix store and probably more
      }

      require("roslyn").setup(opts)
    end,
  },

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
        format_on_save = function(bufnr)
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          return {
            timeout_ms = 500,
            lsp_format = "fallback",
          }
        end,

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

      vim.keymap.set("n", "<leader>uf", function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify("Autoformat (buffer): " .. (vim.b.disable_autoformat and "off" or "on"))
      end, { desc = "Toggle autoformat (buffer)" })

      vim.keymap.set("n", "<leader>uF", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("Autoformat (global): " .. (vim.g.disable_autoformat and "off" or "on"))
      end, { desc = "Toggle autoformat (global)" })
    end,
  },
}
