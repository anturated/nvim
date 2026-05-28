return {
  {
    "gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },

    after = function()
      local opts = {
        on_attach = function(bufnr)
          local gs  = package.loaded.gitsigns

          local map = function(mode, l, r, desc)
            vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
          end

          -- hunk movement
          map("n", "]g", function() gs.nav_hunk("next") end, "Next hunk")
          map("n", "[g", function() gs.nav_hunk("prev") end, "Prev hunk")

          -- hunk actions
          -- TODO: unstage file
          map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
          map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
          map("n", "<leader>gS", gs.stage_buffer, "Stage buffer")
          map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
          map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
          map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
          map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle blame")
          map("n", "<leader>gd", gs.diffthis, "Diff this")

          -- ig stuff
          map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
        end,
      }

      require("gitsigns").setup(opts)
    end
  },
}
