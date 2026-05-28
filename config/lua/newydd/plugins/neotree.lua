return {
  {
    "neo-tree.nvim",

    event = "DeferredUIEnter",
    after = function()
      local opts = {
        close_if_last_window = true,
        window = {
          width = 30,
          mappings = {
            ["l"] = "open",
            ["h"] = "close_node",
          },
        },
        filesystem = {
          filtered_items         = { hide_dotfiles = false, hide_gitignored = true },
          follow_current_file    = { enabled = true },
          use_libuv_file_watcher = true,
        },

        default_component_configs = {
          indent = { with_expanders = true },
          -- git_status = {
          --   symbols = {
          --     added = " ",
          --     modified = "",
          --     deleted = " ",
          --     renamed = " ",
          --     untracked = " ",
          --     ignored = "",
          --     unstaged = " ",
          --     staged = "",
          --     conflict = " ",
          --   },
          -- },
        },
      }

      require("lz.n").trigger_load("nui.nvim")
      require("neo-tree").setup(opts)
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
    end
  },
}
