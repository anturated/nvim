-- netrw is handled by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- true colors
vim.o.termguicolors = true

-- line numbers
vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = "yes:1" -- always show
vim.o.cursorline = true -- highlight the line with the cursor

-- indentation
vim.o.tabstop = 2
vim.o.softtabstop = 0
vim.o.shiftwidth = 2
vim.o.expandtab = true -- tabs to spaces
vim.o.smartindent = true
vim.opt.breakindent = true

-- display
vim.o.wrap = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.opt.list = true -- helps indent blankline
-- vim.o.listchars          = { tab = "→", trail = "·", nbsp = "␣" }
vim.opt.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸" }
vim.opt.showmode = false -- statusline does that

-- search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true

-- splits
vim.o.splitbelow = true
vim.o.splitright = true

-- files
vim.o.undofile = true -- persistent undo across sessions
vim.o.swapfile = false
vim.o.backup = false -- no

-- performance
vim.o.updatetime = 200 -- faster CursorHold (gitsigns, illuminate)
vim.o.timeoutlen = 300 -- which-key popup delay

-- misc
vim.o.clipboard = "unnamedplus"
vim.o.mouse = "a"
vim.o.pumheight = 10 -- max completion items shown
vim.opt.conceallevel = 0
vim.o.cmdheight = 0
vim.o.showtabline = 2
vim.o.laststatus = 3
vim.opt.shortmess:append("sIc") -- suppress various noisy messages
vim.o.title = true
vim.o.titlestring = "%{fnamemodify(getcwd(), ':~')} - Nvim"

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "󰋇",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  float = {
    border = "rounded",
    max_width = 80,
    max_height = 20,
  },
})
