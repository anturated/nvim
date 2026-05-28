return {
  {
    "evergarden-nvim",
    priority = 1000,
    after = function()
      local opts = {
        editor = { transparent_background = true },
        theme = {
          variant = "winter",
          accent = "purple",
        },
      }

      require("evergarden").setup(opts)
      vim.cmd.colorscheme("evergarden")
    end,
  },
}
