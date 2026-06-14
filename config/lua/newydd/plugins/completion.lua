return {
  -- auto tag close
  {
    "nvim-ts-autotag",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "blink.cmp",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        keymap = {
          preset = "default",
          -- i'm weird like that
          ["<C-j>"] = { "select_next", "snippet_forward", "fallback" },
          ["<C-k>"] = { "select_prev", "snippet_backward", "fallback" },
          ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },

          ["<CR>"] = { "accept", "fallback" },
          ["<C-e>"] = { "hide" },
          ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
        },

        snippets = { preset = "default" },

        appearance = {
          nerd_font_variant = "mono",
          kind_icons = {}, -- use mini.icons
        },

        completion = {
          -- TODO: what's this
          trigger = {
            show_on_keyword = true,
          },

          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },

          menu = {
            min_width = vim.o.pumwidth,
            max_height = vim.o.pumheight,
            border = "rounded",
            draw = {
              columns = {
                { "label", "label_description", gap = 1 },
                { "kind_icon", "kind" },
              },
            },
          },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = { border = "rounded" },
          },

          ghost_text = { enabled = true },
        },

        signature = {
          enabled = true,
          window = { border = "rounded" },
        },

        sources = {
          default = { "lsp", "path", "snippets", "buffer" },

          -- load custom snippets
          providers = { snippets = { opts = { search_paths = { vim.g.snippets_path } } } },

          transform_items = function(_, items)
            return vim
              .iter(ipairs(items))
              :map(function(_, item)
                if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                  item.score_offset = item.score_offset + 1
                end
                return item
              end)
              :totable()
          end,
          min_keyword_length = function()
            local default = 1
            return vim.bo.filetype == "markdown" and 2 or default
          end,
        },

        fuzzy = {
          max_typos = function(_)
            return 0
          end,
          -- proximity bonus boosts the score of items matching nearby words
          use_proximity = true,

          prebuilt_binaries = {
            download = false,
          },
        },
      }

      require("blink.cmp").setup(opts)
    end,
  },
}
