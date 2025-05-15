local figio = require('figtree.io')
local utils = require('figtree.utils')

M = {}

--- Precomputes window size agnostic stuff for the draw() closure
function M.mk_draw(state)
  -- prep that is window size agnostic
  local body = figio.get_banner(state)
  local ver_string = utils.version_string()
  local lines = vim.split(body, '\n', { trimempty = true })
  local tx = #lines[1] -- assuming all lines have equal width
  local ty = #lines
  -- center align the version string with the main block
  ver_string = string.rep(' ', math.floor((tx - #ver_string) / 2)) .. ver_string
  -- add some space between the two
  local spacing = 3
  local space = utils.empty(spacing)
  ty = ty + spacing + 1

  -- renders buffers final contents, that are adjusted to the window size
  local render = function()
    local wx = vim.fn.winwidth(0)
    local wy = vim.fn.winheight(0)

    local xpad = math.floor((wx - tx) / 2)
    local ypad = math.floor((wy - ty) / 2)

    if xpad <= 0 or ypad <= 0 then
      -- body doesn't fit, hide
      return {}
    end

    local prefix = string.rep(' ', xpad)
    local head = utils.empty(ypad)

    local parts = {
      head,
      utils.prefix_lines(lines, prefix),
      space,
      utils.prefix_lines({ ver_string }, prefix),
    }

    return utils.concat_list(parts)
  end

  -- fills the buffer with the rendered contents
  state.draw = function()
    vim.opt_local.modifiable = true
    vim.api.nvim_buf_set_lines(0, 0, -1, false, render())
    vim.opt_local.modifiable = false
  end
end

return M
