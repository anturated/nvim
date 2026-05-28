-- keybinds need to happen before plugin loading
require("newydd.config.autocmds")
require("newydd.config.treesitter")
require("newydd.config.keymaps")
require("newydd.config.options")

require("lz.n").load("newydd.plugins")

-- lsp config after plugins loaded
require("newydd.config.servers")
