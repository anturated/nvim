return {
  {
    "snacks.nvim",
    priority = 1000,

    after    = function()
      local snacks = require("snacks")

      -- TODO: maybe steal the dashboard idea

      ---@type snacks.Config
      local opts   = {
        dashboard = {
          enabled = true,
          sections = {
            { section = "header" },
            -- TODO: banner
          },
        },

        terminal  = {
          enabled = true,
          win = { wo = { winbar = "" }, -- remove winbar
          },
        },


        notifier     = { enabled = true, timeout = 3000 },
        picker       = { enabled = true },
        bigfile      = { enabled = true }, -- disable features for large files
        lazygit      = { enabled = true },

        indent       = { enabled = false }, -- blankline handles this
        scope        = { enabled = false },
        statuscolumn = { enabled = false }, -- pretty sign/fold column
        words        = { enabled = false }, -- vim-illuminate handles this
      }

      snacks.setup(opts)

      local keys = {
        -- find stuff
        { "<leader>ff",    function() Snacks.picker.files() end,           desc = "Find files" },
        { "<leader>fw",    function() Snacks.picker.grep() end,            desc = "Find words" },
        { "<leader>fo",    function() Snacks.picker.recent() end,          desc = "Find recent files" },
        { "<leader>fd",    function() Snacks.picker.diagnostics() end,     desc = "Find diagnostics" },
        { "<leader>fk",    function() Snacks.picker.keymaps() end,         desc = "Find keymaps" },
        { "<leader>fc",    function() Snacks.picker.command_history() end, desc = "Find command history" },
        { "<leader>fh",    function() Snacks.picker.highlights() end,      desc = "Find highlights" },
        { "<leader>fT",    function() Snacks.picker.todo_comments() end,   desc = "Find TODOs" },
        { "<leader>ft",    function() Snacks.picker.colorschemes() end,    desc = "Find colorschemes" },
        { "<leader>fn",    function() Snacks.picker.notifications() end,   desc = "Find notifications" },
        -- LSP
        { "<leader>ls",    function() Snacks.picker.lsp_symbols() end,     desc = "Find symbols" },
        -- Terminal
        { "<C-'>",         function() Snacks.terminal() end,               mode = { "n", "t" },          desc = "Toggle terminal" },
        -- escape terminal without closing
        { "<C-h>",         "<C-\\><C-n><C-w>h",                            mode = { "t" },               desc = "Terminal: go left" },
        { "<C-j>",         "<C-\\><C-n><C-w>j",                            mode = { "t" },               desc = "Terminal: go down" },
        { "<C-k>",         "<C-\\><C-n><C-w>k",                            mode = { "t" },               desc = "Terminal: go up" },
        { "<C-l>",         "<C-\\><C-n><C-w>l",                            mode = { "t" },               desc = "Terminal: go right" },
        -- Misc
        { "<leader>gg",    function() Snacks.lazygit() end,                desc = "LazyGit" },
        { "<leader>gf",    function() Snacks.lazygit.log_file() end,       desc = "LazyGit file log" },
        { "<leader>f<CR>", function() Snacks.picker.resume() end,          desc = "Resume last picker" },
      }

      -- yuck but eh
      for _, key in ipairs(keys) do
        vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
      end
    end,
  }
}
