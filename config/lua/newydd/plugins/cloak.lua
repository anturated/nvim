return {
  {
    "cloak.nvim",

    event = "BufAdd",
    after = function()
      local opts = {
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",

        cloak_length = nil,
        try_all_patterns = true,
        cloak_telescope = true,

        patterns = {
          {
            file_pattern = {
              ".env",
              ".env.local",
              ".env.dev",
              ".env.development",
            },

            cloak_pattern = { "=.+" },
          },
        },
      }

      require("cloak").setup(opts)
    end,
  },
}
