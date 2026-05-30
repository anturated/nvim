return {
  {
    "lualine.nvim",

    event = "DeferredUIEnter",
    after = function()
      local opts = {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = {},
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {
              "snacks_dashboard",
            },
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = true,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              "WinEnter",
              "BufEnter",
              "BufWritePost",
              "SessionLoadPost",
              "FileChangedShellPost",
              "VimResized",
              "Filetype",
              "CursorMoved",
              "CursorMovedI",
              "ModeChanged",
            },
          },
        },

        sections = {
          lualine_a = {
            function()
              return vim.fn.mode(1):sub(1, 1)
            end,
          },
          lualine_b = {
            { "branch", icon = "" },
            "diff",
          },
          lualine_c = { "diagnostics" },

          lualine_x = {
            {
              function()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                return table.concat(
                  vim.tbl_map(function(c)
                    return c.name
                  end, clients),
                  ", "
                )
              end,
              cond = function()
                return #vim.lsp.get_clients({ bufnr = 0 }) ~= 0
              end,
            },
          },
          lualine_y = {
            {
              function()
                return ""
              end,
              cond = function()
                return vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil
              end,
            },
            "filetype",
            "location",
          },
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},

        winbar = {
          lualine_c = { "navic" },
          lualine_x = {
            {
              function()
                return "  "
              end,
              cond = function()
                local present, navic = pcall(require, "nvim-navic")
                if not present then
                  return false
                end
                return navic.is_available()
              end,
            },
          },
        },
        inactive_winbar = {
          lualine_c = { "navic" },
          lualine_x = {
            {
              function()
                return "  "
              end,
              cond = function()
                local present, navic = pcall(require, "nvim-navic")
                if not present then
                  return false
                end
                return navic.is_available()
              end,
            },
          },
        },
        extensions = {},
      }

      require("lualine").setup(opts)
    end,
  },
}
