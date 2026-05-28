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
          filtered_items = { hide_dotfiles = false, hide_gitignored = true },
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
        },

        default_component_configs = {
          indent = { with_expanders = true },
          filesystem = {
            filtered_items = {
              visible = true,
              hide_dotfiles = false,
            },
            use_libuv_file_watcher = true,
          },
          -- NOTE: idk if this is better than what i had with web icons but i'm too tired for now
          icon = {
            provider = function(icon, node) -- setup a custom icon provider
              local text, hl
              local mini_icons = require("mini.icons")
              if node.type == "file" then -- if it's a file, set the text/hl
                text, hl = mini_icons.get("file", node.name)
              elseif node.type == "directory" then -- get directory icons
                text, hl = mini_icons.get("directory", node.name)
                -- only set the icon text if it is not expanded
                if node:is_expanded() then
                  text = nil
                end
              end

              -- set the icon text/highlight only if it exists
              if text then
                icon.text = text
              end
              if hl then
                icon.highlight = hl
              end
            end,
          },
          kind_icon = {
            provider = function(icon, node)
              local mini_icons = require("mini.icons")
              icon.text, icon.highlight = mini_icons.get("lsp", node.extra.kind.name)
            end,
          },
        },
      }

      require("lz.n").trigger_load("nui.nvim")
      require("neo-tree").setup(opts)
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })
    end,
  },
}
