local M = {}

M.letter_to_buf = {}
M.buf_to_letter = {}
M.is_picking = false

local function listed_bufs()
  return vim.tbl_filter(function(b)
    return vim.bo[b].buflisted and vim.api.nvim_buf_is_valid(b)
  end, vim.api.nvim_list_bufs())
end

-- assign letter to buf
function M.assign()
  M.letter_to_buf = {}
  M.buf_to_letter = {}
  local used      = {}
  local pending   = {}

  for _, buf in ipairs(listed_bufs()) do
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t:r")
    if name == "" then name = "scratch" end
    local assigned = false
    for i = 1, #name do
      local ch = name:sub(i, i):lower()
      if ch:match("[a-z]") and not used[ch] then
        used[ch]             = true
        M.letter_to_buf[ch]  = buf
        M.buf_to_letter[buf] = ch
        assigned             = true
        break
      end
    end
    if not assigned then table.insert(pending, buf) end
  end

  -- fallback
  for _, buf in ipairs(pending) do
    for _, ch in ipairs(vim.split("abcdefghijklmnopqrstuvwxyz", "")) do
      if not used[ch] then
        used[ch]             = true
        M.letter_to_buf[ch]  = buf
        M.buf_to_letter[buf] = ch
        break
      end
    end
  end
end

-- this triggers on <leader>bb
function M.pick(callback)
  -- give each buffer a letter
  M.assign()

  -- highlight the letter and force tabline to redraw
  M.is_picking = true
  vim.cmd("redrawtabline")

  local hints = {}
  for letter, buf in pairs(M.letter_to_buf) do
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
    if name == "" then name = "[No Name]" end
    table.insert(hints, string.format("[%s]%s", letter, name))
  end
  table.sort(hints)

  -- wait for buffer letter input
  local ok, ch = pcall(vim.fn.getcharstr)

  -- no hl, redraw
  M.is_picking = false
  vim.cmd("redrawtabline")

  -- if it was <esc> do nothing
  if not ok or ch == "\27" then return end

  -- otherwise go to the buffer
  local buf = M.letter_to_buf[ch]
  if buf then callback(buf) end
end

function M.setup()
  M.assign()
  vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete", "BufWipeout", "SessionLoadPost" }, {
    callback = function() M.assign() end,
  })
end

return M
