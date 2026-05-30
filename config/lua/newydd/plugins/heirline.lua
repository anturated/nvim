-- A lion does not concern himself with figuring out how to configure bufferline.nvim
-- lualine is good enough for status bar tho

return {
  {
    "heirline.nvim",

    event = "DeferredUIEnter",
    after = function()
      local heirline = require("heirline")
      local utils = require("heirline.utils")
      local buf_nav = require("newydd.lib.buf_nav")

      -- auto reloaded on colorscheme and loaded on... load.
      -- HACK: this just doesn't feel right
      -- but oh well
      local function setup_colors()
        return {
          TabLineBg = utils.get_highlight("TabLine").bg,
          TabLineFg = utils.get_highlight("TabLine").fg,
          TabLineSelBg = utils.get_highlight("TabLineSel").bg,
          TabLineSelFg = utils.get_highlight("TabLineSel").fg,
          TabLineFillBg = utils.get_highlight("TabLineFill").bg,
          TabLineFillFg = utils.get_highlight("TabLineFill").fg,
          GitSignsDeleteFg = utils.get_highlight("GitSignsDelete").fg,
        }
      end

      local function hl(name)
        return {
          bg = name .. "Bg",
          fg = name .. "Fg",
        }
      end

      ------------------------------------
      --- THE BIG AND HORRIBLE TABLINE ---
      ------------------------------------

      -- the filename that's written on the tab
      local TablineFileName = {
        -- we do a lot of funky stuff with the filename first
        init = function(self)
          local fullpath = vim.api.nvim_buf_get_name(self.bufnr)
          local name

          if fullpath == "" then
            -- ignore and rename empty tab
            name = "[No Name]"
          else
            -- otherwise grab filename
            local tail = vim.fn.fnamemodify(fullpath, ":t")

            -- see if we have tabs with that same name
            local dupes = vim.tbl_filter(function(b)
              return b ~= self.bufnr
                and vim.bo[b].buflisted
                and vim.api.nvim_buf_is_valid(b)
                and vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t") == tail
            end, vim.api.nvim_list_bufs())

            if #dupes == 0 then
              -- if not, just use the filename
              name = tail
            else
              -- otherwise add path segments until unique
              local rel = vim.fn.fnamemodify(fullpath, ":~:.")
              local parts = vim.split(rel, "/")
              name = tail

              for i = #parts - 1, 1, -1 do
                local candidate = table.concat(parts, "/", i)
                local still_dupes = vim.tbl_filter(function(b)
                  local other = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":~:.")
                  return other:sub(-#candidate) == candidate
                end, dupes)
                name = candidate
                if #still_dupes == 0 then
                  break
                end
              end
            end
          end

          -- assign letter for <leader>bb
          local letter = buf_nav.buf_to_letter[self.bufnr]

          -- if successful, split the name accounting for the letter
          if letter then
            local pos = name:lower():find(letter, 1, true)

            if pos then
              self.pre = name:sub(1, pos - 1)
              self.hi = name:sub(pos, pos)
              self.suf = name:sub(pos + 1)
              return
            end
          end

          -- if not just give up
          self.pre, self.hi, self.suf = name, "", ""
        end,

        -- highlight for the name
        hl = function(self)
          local active = self.is_active or self.is_visible
          return { bold = active, italic = active }
        end,

        -- THIS IS THE ACTUAL STRUCTURE
        { provider = " " },
        {
          provider = function(self)
            return self.pre
          end,
        },
        {
          provider = function(self)
            return self.hi
          end,

          -- highlight for the one letter
          hl = function()
            if buf_nav.is_picking then
              -- HACK: probably doesn't go well with red accents
              return { fg = hl("GitSignsDelete").fg, bold = true, underline = true }
            else
              return nil
            end
          end,
        },
        {
          provider = function(self)
            return self.suf
          end,
        },
        { provider = " " },
      }

      -- modified, locked, terminal
      local TablineFileFlags = {
        {
          condition = function(self)
            return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
          end,
          provider = " ●",
        },
        {
          condition = function(self)
            return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
              or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
          end,

          provider = function(self)
            if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
              return "  "
            else
              return " "
            end
          end,
        },
      }

      -- the entire name with flags and such
      local TablineFileNameBlock = {
        init = function(self)
          self.filename = vim.api.nvim_buf_get_name(self.bufnr)
        end,

        -- do this so it inherits foreground
        hl = function(self)
          if self.is_active then
            return hl("TabLineSel")
          else
            return hl("TabLine")
          end
        end,

        -- close on middle click or open
        on_click = {
          callback = function(_, minwid, _, button)
            if button == "m" then -- middle mouse button
              vim.schedule(function()
                vim.api.nvim_buf_delete(minwid, { force = false })
              end)
            else -- other buttone lmao
              vim.api.nvim_win_set_buf(0, minwid)
            end
          end,

          minwid = function(self)
            return self.bufnr
          end,

          name = "heirline_tabline_buffer_callback",
        },

        TablineFileFlags,
        TablineFileName,
      }

      -- tab component used below
      local TablineBufferBlock = utils.surround({ "", "" }, function(self)
        if self.is_active then
          return hl("TabLineSel").bg
        else
          return hl("TabLine").bg
        end
      end, TablineFileNameBlock)

      -- the assembled bufferline
      local BufferLine = utils.make_buflist(
        TablineBufferBlock,
        { provider = "  ", hl = { fg = "TabLineFillFg" } },
        { provider = "  ", hl = { fg = "TabLineFillFg" } }
      )

      -----------------------
      --- THE ACTUAL OPTS ---
      -----------------------

      local opts = {
        tabline = BufferLine,
      }

      buf_nav.setup()
      heirline.setup(opts)
      heirline.load_colors(setup_colors)

      -- auto reload colors on colorscheme
      vim.api.nvim_create_augroup("Heirline", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          utils.on_colorscheme(setup_colors)
        end,
        group = "Heirline",
      })

      ------------------------------------
      --- THE EVER COMPLICATED KEYMAPS ---
      ------------------------------------

      -- switch with shift h/l
      vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
      vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })

      -- the ever complicated close
      -- i don't even remember what the problem with it was but this works
      -- and i'm not gonna be the one to touch this until i'm very bored
      vim.keymap.set("n", "<leader>c", function()
        local cur = vim.api.nvim_get_current_buf()
        local listed = vim.tbl_filter(function(b)
          return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b) and b ~= cur
        end, vim.api.nvim_list_bufs())
        if #listed == 0 then
          vim.cmd("enew")
        else
          vim.api.nvim_set_current_buf(listed[#listed])
        end
        vim.cmd("bdelete " .. cur)
      end, { desc = "Delete buffer" })

      -- force close
      vim.keymap.set("n", "<leader>C", "<cmd>bdelete!<cr>", { desc = "Force delete buffer" })

      -- <leader>bb[a-z]: jump to labelled buffer
      vim.keymap.set("n", "<leader>bb", function()
        buf_nav.pick(function(buf)
          vim.api.nvim_set_current_buf(buf)
        end)
      end, { desc = "Interactive buffer picker" })

      -- close left
      vim.keymap.set("n", "<leader>bl", function()
        local cur = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf == cur then
            break
          end
          if vim.bo[buf].buflisted then
            vim.cmd("bdelete " .. buf)
          end
        end
      end, { desc = "Buffer: close left" })

      -- close right
      vim.keymap.set("n", "<leader>br", function()
        local cur = vim.api.nvim_get_current_buf()
        local past = false
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if past then
            if vim.bo[buf].buflisted then
              vim.cmd("bdelete " .. buf)
            end
          elseif buf == cur then
            past = true
          end
        end
      end, { desc = "Buffer: close right" })

      -- close others
      vim.keymap.set("n", "<leader>bc", function()
        local cur = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf ~= cur and vim.bo[buf].buflisted then
            vim.cmd("bdelete " .. buf)
          end
        end
      end, { desc = "Buffer: close others" })

      -- split and pick horizontal
      vim.keymap.set("n", "<leader>b\\", function()
        vim.cmd("split")
        buf_nav.pick(function(buf)
          vim.api.nvim_set_current_buf(buf)
        end)
      end, { desc = "Split horizontal + pick buffer" })
      -- vertical
      vim.keymap.set("n", "<leader>b|", function()
        vim.cmd("vsplit")
        buf_nav.pick(function(buf)
          vim.api.nvim_set_current_buf(buf)
        end)
      end, { desc = "Split vertical + pick buffer" })
    end,
  },
}
