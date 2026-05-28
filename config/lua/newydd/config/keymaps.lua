vim.g.mapleader = " "


vim.keymap.set("n", "j", "gj", { desc = "Down (visual line)" })
vim.keymap.set("n", "k", "gk", { desc = "Up (visual line)" })


-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

---------------
--- editing ---
---------------

-- keep selection after indent
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Indent left" })
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent right" })

-- move selected lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

-- best vim.keymap.set ever
-- vim.keymap.set("v", "p", '"_dP', { desc = "Paste without yanking selection" })
-- FIXME: this sometimes breaks for some stupid reason

--------------
--- center ---
--------------

-- TODO: clear search hl on any input
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- center search result
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- center scroll
vim.keymap.set("n", "<C-d>", "<C-d>zzzv")
vim.keymap.set("n", "<C-u>", "<C-u>zzzv")

-------------------
--- diagnostics ---
-------------------

-- FIXME: honestly try trouble?
-- this whole thing feels so ass

-- i don't remember what this is
local diag_float_win = nil

-- HACK: this feels off but the diagnostics window is ass otherwise
local function open_diag_float()
  if diag_float_win and vim.api.nvim_win_is_valid(diag_float_win) then
    vim.api.nvim_win_close(diag_float_win, true)
  end
  local _, win = vim.diagnostic.open_float({
    scope      = "line",
    border     = "rounded",
    header     = false, -- removes the blank line + "Diagnostics:" label
    source     = "if_many",
    prefix     = function(_, i, _) return i > 1 and string.format("%d. ", i) or "" end,
    max_width  = 80,
    max_height = 20,
    focusable  = false,
  })
  diag_float_win = win
end

local function diag_jump(opts)
  vim.diagnostic.jump(opts)
  vim.schedule(open_diag_float)
end

vim.keymap.set("n", "<leader>ld", open_diag_float, { desc = "Line diagnostics" })

vim.keymap.set("n", "]d", function() diag_jump({ count = 1 }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function() diag_jump({ count = -1 }) end, { desc = "Prev diagnostic" })

vim.keymap.set("n", "]w", function() diag_jump({ count = 1, severity = vim.diagnostic.severity.WARN }) end,
  { desc = "Next warning" })
vim.keymap.set("n", "[w", function() diag_jump({ count = -1, severity = vim.diagnostic.severity.WARN }) end,
  { desc = "Prev warning" })

vim.keymap.set("n", "]e", function() diag_jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Next error" })
vim.keymap.set("n", "[e", function() diag_jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end,
  { desc = "Prev error" })

------------
--- misc ---
------------

vim.keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

------------------------------
--- which-key group labels ---
------------------------------

-- FIXME: move to whichkey?
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "LazyDone",
--   callback = function()
--     local ok, wk = pcall(require, "which-key")
--     if not ok then return end
--     wk.add({
--       { "<leader>b", group = "buffers" },
--       { "<leader>f", group = "find / files" },
--       { "<leader>g", group = "git" },
--       { "<leader>u", group = "ui" },
--       { "<leader>x", group = "diagnostics / quickfix" },
--     })
--   end,
-- })
