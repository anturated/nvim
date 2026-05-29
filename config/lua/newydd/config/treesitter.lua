vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "c",
    "comment",
    "cpp",
    "cs",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "just",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "qmldir",
    "qmljs",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },

  callback = function(ev)
    vim.api.nvim_buf_call(ev.buf, function()
      vim.treesitter.start()
    end)
  end,
})
