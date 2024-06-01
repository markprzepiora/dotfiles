require("flash").setup({
  modes = {
    search = {
      enabled = false
    },
    char = {
      enabled = false
    },
  },
})

vim.keymap.set(
  {'n', 'x', 'o'},
  '<leader>s',
  function() require("flash").jump() end,
  { noremap = true, silent = true }
)

vim.keymap.set(
  {'n', 'x', 'o'},
  '<leader>S',
  function() require("flash").treesitter() end,
  { noremap = true, silent = true }
)

vim.keymap.set(
  {'n', 'x', 'o'},
  '<leader>r',
  function() require("flash").remote() end,
  { noremap = true, silent = true }
)

vim.keymap.set(
  {'n', 'x', 'o'},
  '<leader>R',
  function() require("flash").treesitter_search() end,
  { noremap = true, silent = true }
)
