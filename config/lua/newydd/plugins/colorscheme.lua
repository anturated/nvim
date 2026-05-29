return {
  {
    "evergarden-nvim",
    priority = 1000,
    after = function()
      local evergarden = require("evergarden")

      local opts = {
        editor = { transparent_background = true },
        theme = {
          variant = "winter",
          accent = "lime",
        },
      }

      evergarden.setup(opts)
      vim.cmd.colorscheme("evergarden")

      vim.api.nvim_create_user_command("NewyddAccent", function(opts_)
        local accent = opts_.args
        opts.theme.accent = accent

        require("evergarden").setup(opts)
        vim.cmd("colorscheme evergarden")
        vim.notify("Switched accent to " .. accent)
      end, {
        nargs = 1,
        desc = "Set colorscheme accent",
      })
    end,
  },
}
