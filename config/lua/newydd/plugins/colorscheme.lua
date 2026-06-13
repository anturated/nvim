return {
  {
    "evergarden-nvim",
    priority = 1000,
    after = function()
      local evergarden = require("evergarden")
      local accent_file = vim.fn.stdpath("data") .. "/newydd_accent"

      local function save_accent(accent)
        local f = io.open(accent_file, "w")
        if f then
          f:write(accent)
          f:close()
        end
      end

      local function load_accent()
        local f = io.open(accent_file, "r")
        if f then
          local accent = f:read("*l")
          f:close()
          return accent
        end
      end

      local opts = {
        editor = { transparent_background = true },
        theme = {
          variant = "winter",
          accent = load_accent() or "lime",
        },
      }

      evergarden.setup(opts)
      vim.cmd.colorscheme("evergarden")

      vim.api.nvim_create_user_command("NewyddAccent", function(opts_)
        local accent = opts_.args
        opts.theme.accent = accent
        save_accent(accent)

        require("evergarden").setup(opts)
        vim.cmd("colorscheme evergarden")
        vim.notify("Switched accent to " .. accent)
      end, {
        nargs = 1,
        desc = "Set colorscheme accent",
      })
    end,
  },

  {
    "nightfox.nvim",

    after = function()
      local opts = {
        options = {
          transparent = true,
        },
      }

      require("nightfox").setup(opts)
    end,
  },
}
