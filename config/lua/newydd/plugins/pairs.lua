return {
  {
    "nvim-autopairs",
    event = "DeferredUIEnter",
    after = function()
      local opts = {
        check_ts = true, -- treesitter integration that FIXME: doesn't work???
        ts_config = { lua = { "string" }, javascript = { "template_string" } },
        fast_wrap = { map = "<M-e>" },
      }
      require("nvim-autopairs").setup(opts)
    end,
  },
  {
    "nvim-surround",
    event = "DeferredUIEnter",
    after = function()
      require("nvim-surround").setup()
    end,
  },
}
