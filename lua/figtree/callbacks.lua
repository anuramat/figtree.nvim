local m = {}

---@param state state
local function hide_cursor(state)
  state.gcr = vim.opt.guicursor
  local hl = vim.api.nvim_get_hl(0, { name = 'Cursor' })
  hl.blend = 100
  vim.api.nvim_set_hl(0, 'HiddenCursor', hl)
  vim.opt.guicursor:append('a:HiddenCursor,ci-c-cr:Cursor')
end

---@param state state
local function unhide_cursor(state) vim.opt.guicursor = state.gcr end

--- Startup callback
---@param state state
---@param config config
local function enter(state, config)
  -- skip greeter when opening files
  if vim.fn.argc() ~= 0 then return end

  -- greet
  state.draw()
  hide_cursor(state)

  -- when a new window is created, replace the greeter buffer with an empty buffer
  local old = vim.fn.win_getid()
  vim.api.nvim_create_autocmd('WinNew', {
    buffer = 1,
    callback = function(ev)
      unhide_cursor(state)
      local buf = vim.api.nvim_create_buf(true, false)
      vim.api.nvim_win_set_buf(old, buf)
      if ev.buf == 1 then vim.api.nvim_win_set_buf(0, buf) end
    end,
    once = true,
  })

  -- when the buffer is closed, unhide the cursor
  vim.api.nvim_create_autocmd('BufDelete', {
    buffer = 1,
    callback = function() unhide_cursor(state) end,
    once = true,
  })

  -- rerender on resize
  vim.api.nvim_create_autocmd('VimResized', {
    buffer = 1,
    callback = state.draw,
  })

  -- make the buffer special
  -- luacheck: ignore 613 -- trailing whitespace
  vim.cmd([[
      setl bh=wipe bt=nofile scl=no siso=0
      setl fcs+=eob:\ 
      setl nocul nolist noma nonu nornu noswf ro
      setl stl=\ 
      ]])

  -- apply remaps for the greeter buffer
  config.remaps()
end

---@param state state
---@param config config
---@return function
function m.enter(state, config)
  return function() enter(state, config) end
end

return m
