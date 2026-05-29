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

  {
    "formatter.nvim",
    event = "DeferredUIEnter",
    after = function()
      require("formatter").setup({
        filetype = {
          lua = { require("formatter.filetypes.lua").stylua },
          nix = { require("formatter.filetypes.nix").nixfmt },
          sh = { require("formatter.filetypes.sh").shfmt },
          bash = { require("formatter.filetypes.sh").shfmt },
          toml = { require("formatter.filetypes.toml").taplo },
        },
      })

      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd
      augroup("__formatter__", { clear = true })
      autocmd("BufWritePost", {
        group = "__formatter__",
        command = ":FormatWrite",
      })
    end,
  },
}
