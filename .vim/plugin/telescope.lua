local actions = require "telescope.actions"
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  },
  pickers = {
    find_files = {
      find_command = { "find_src_files" },
    },
  },
}

vim.keymap.set(
  {'n'},
  '<leader>f',
  '<cmd>Telescope find_files<cr>',
  { noremap = true }
)

vim.keymap.set(
  {'n'},
  '<leader>F',
  ':lua require("telescope.builtin").find_files({cwd = require("telescope.utils").buffer_dir()})<cr>',
  { noremap = true }
)

vim.keymap.set(
  {'n', 'v'},
  '<leader>b',
  '<cmd>Telescope grep_string<cr>',
  { noremap = true }
)
