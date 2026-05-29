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
