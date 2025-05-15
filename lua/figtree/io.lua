M = {}

---@return string output, boolean ok
local function figlet(state)
  local res = vim.system({ 'figlet', '-w', '999', '-f', state.config.font, state.config.text }, { text = true }):wait()
  if res.code ~= 0 then return string.format('figlet error: %s', res.stderr), false end
  return res.stdout, true
end

-- TODO invalidation
---@return string
function M.get_banner(state)
  local dir = vim.fn.stdpath('cache') .. '/figtree.nvim'
  vim.fn.mkdir(dir, 'p')
  local filename = dir .. string.format('/%s.txt', state.config.font)
  local chars
  local file = io.open(filename, 'r')
  if file ~= nil then
    chars = file:read('*a')
    file:close()
  else
    local ok
    chars, ok = figlet(state)
    if ok then
      file = io.open(filename, 'w')
      if file == nil then
        M.err(string.format('couldn\'t open %s for writing', filename))
      else
        file:write(chars)
        file:close()
      end
    end
  end
  return chars
end

return M
