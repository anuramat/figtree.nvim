# figtree.nvim

figlet startup banner for neovim

## Usage

using lazy.nvim, with all defaults explicitly specified:

```lua
local x = {
  'anuramat/figtree.nvim',
  opts = {
    {
      text = 'neovim',
      font = 'fraktur',
      show_version = {
        enabled = true,
        spacing = 3,
      },
      remaps = function()
        local allowed_keys = vim.split(':`', '')
        require('figtree.utils').unmap(allowed_keys)
        vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>quit<cr>', {})
        vim.api.nvim_buf_set_keymap(0, 'n', 'i', '<cmd>enew<cr>i', {})
        vim.api.nvim_buf_set_keymap(0, 'n', 'a', '<cmd>enew<cr>a', {})
      end,
    },
  },
}
```
