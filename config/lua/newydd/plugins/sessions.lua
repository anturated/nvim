return {
  {
    "resession.nvim",

    event = "DeferredUIEnter",
    after = function()
      local resession = require("resession")

      local opts = {
        autosave = {
          enabled = true,
          interval = 60,
          notify = false,
        },
        dir = "dirsession", -- subdir inside stdpath("data")
      }

      resession.setup(opts)

      ----------------
      --- AUTOCMDS ---
      ----------------

      -- autosave on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          resession.save(vim.fn.getcwd(), { dir = "dirsession", notify = false })
        end,
      })

      -- directories to exclude from auto-loading
      local excluded_dirs = {
        vim.env.HOME,
        "/tmp",
        "/",
      }

      -- auto load on startup
      local function should_load_session()
        local cwd = vim.fn.getcwd()
        for _, dir in ipairs(excluded_dirs) do
          if cwd == dir then
            return false
          end
        end
        return true
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardClosed",
        group = vim.api.nvim_create_augroup("newydd.dashboard-restore", { clear = true }),
        callback = function()
          vim.schedule(function()
            if vim.fn.argc() == 0 and should_load_session() then
              resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
            end
          end)
        end,
        nested = true,
      })

      ---------------
      --- KEYMAPS ---
      ---------------

      vim.keymap.set("n", "<leader>ss", function()
        require("resession").save()
      end, { desc = "Save session" })

      vim.keymap.set("n", "<leader>sl", function()
        require("resession").load()
      end, { desc = "Load session" })

      vim.keymap.set("n", "<leader>s.", function()
        require("resession").load(vim.fn.getcwd(), { dir = "dirsession" })
      end, { desc = "Load dir session" })

      vim.keymap.set("n", "<leader>sf", function()
        local sessions = require("resession").list({ dir = "dirsession" })
        vim.ui.select(sessions, { prompt = "Load dir session:" }, function(choice)
          if choice then
            require("resession").load(choice, { dir = "dirsession" })
          end
        end)
      end, { desc = "Find dir session" })

      vim.keymap.set("n", "<leader>sd", function()
        local sessions = require("resession").list({ dir = "dirsession" })
        vim.ui.select(sessions, { prompt = "Delete dir session:" }, function(choice)
          if choice then
            require("resession").delete(choice, { dir = "dirsession" })
          end
        end)
      end, { desc = "Delete dir session" })
    end,
  },
}
