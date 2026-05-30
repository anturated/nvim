return {
  {
    "vim-wakatime",
    event = "VimEnter",
    enabled = function()
      return vim.fn.glob("$WAKATIME_HOME/.wakatime.cfg") ~= "" or vim.fn.glob("~/.wakatime.cfg") ~= ""
    end,
  },
}
