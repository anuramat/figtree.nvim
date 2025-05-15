M = {}

local root = vim.fn.stdpath('cache') .. '/figtree.nvim'
local dir = root .. '/banners'
local textfile = root .. '/text.txt'

---@return string output, boolean ok
local function figlet(state)
  local res = vim.system({ 'figlet', '-w', '999', '-f', state.config.font, state.config.text }, { text = true }):wait()
  if res.code ~= 0 then return string.format('figlet error: %s', res.stderr), false end
  return res.stdout, true
end

local function write_error(filename) M.err(string.format('couldn\'t open %s for writing', filename)) end

local function save_text(text)
  local file = io.open(textfile, 'w')
  if file == nil then
    write_error(textfile)
  else
    file:write(text)
    file:close()
  end
end

local function text_changed(text)
  local file = io.open(textfile, 'w')
  if file == nil then
    return true
  else
    local contents = file:read('*a')
    file:close()
    return contents == text
  end
end

---@return string
function M.get_banner(state)
  vim.fn.mkdir(dir, 'p')
  local filename = dir .. string.format('/%s.txt', state.config.font)
  if text_changed(state.text) then
    vim.fn.delete(dir, 'rf')
    save_text(state.text)
  end
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
        write_error(filename)
      else
        file:write(chars)
        file:close()
      end
    end
  end
  return chars
end

return M
