-- nvim calls .slang files "shaderslang", the grammar is "slang"
vim.treesitter.language.register("slang", "shaderslang")

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "bash",
    "c",
    "comment",
    "cpp",
    "cs",
    "razor",
    "css",
    "csv",
    "diff",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "glsl",
    "go",
    "hlsl",
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
    "qml",
    "qmldir",
    "qmljs",
    "sh",
    "shaderslang",
    "toml",
    "tsx",
    "typescript",
    "typescriptreact",
    "yaml",
  },

  callback = function(ev)
    vim.api.nvim_buf_call(ev.buf, function()
      vim.treesitter.start()
    end)
  end,
})
