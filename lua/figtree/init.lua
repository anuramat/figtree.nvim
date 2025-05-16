local M = {}

local callbacks = require('figtree.callbacks')
local render = require('figtree.render')
local utils = require('figtree.utils')

---@type opts
local defaults = {
  text = 'neovim',
  font = 'fraktur',
  remaps = function()
    local allowed_keys = vim.split(':`', '')
    utils.unmap(allowed_keys)
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>quit<cr>', {})
    vim.api.nvim_buf_set_keymap(0, 'n', 'i', '<cmd>enew<cr>i', {})
    vim.api.nvim_buf_set_keymap(0, 'n', 'a', '<cmd>enew<cr>a', {})
  end,
}

---@param opts opts?
M.setup = function(opts)
  local state = {}
  local config = vim.tbl_deep_extend('force', defaults, opts or {})
  render.mk_draw(state, config)
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = callbacks.enter(state, config),
  })
end

return M
