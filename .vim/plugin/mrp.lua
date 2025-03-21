local M = {}

--- Gets the number of leading spaces for a given line.
local function get_indentation(line)
  -- We look for leading whitespace and return its length.
  local leading = line:match('^%s*') or ''
  return #leading
end

function M.yank_fully_qualified_method_name()
  -- 1. Get the method name under the cursor (the "word").
  local method_name = vim.fn.expand("<cword>")

  -- 2. Determine indentation level of current line.
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line_num = cursor_pos[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local current_line = lines[current_line_num]
  if not current_line then
    return
  end
  local current_indent = get_indentation(current_line)

  -- We'll build the final string from inside (method) -> outward (classes/modules).
  local fully_qualified = method_name
  -- The first time we prepend a class/module, we use '.', subsequent times use '::'.
  local suffix = '.'

  -- 3 & 4. Traverse backward until no more class/module definitions or indentation is out of range.
  local line_index = current_line_num - 1
  while line_index > 0 do
    local line = lines[line_index]
    local indent = get_indentation(line)

    -- We only consider lines whose indent <= (current_indent - 1).
    -- Then we check if they start with "class " or "module ".
    if indent <= current_indent - 1 then
      -- Match class or module name (including a possible "< ParentClass" after).
      local class_part = line:match("^%s*class%s+([%S]+)") or
                         line:match("^%s*module%s+([%S]+)")

      if class_part then
        -- In Ruby, definitions can be like "class Foo < Bar", so capture just the first token.
        class_part = class_part:match("^([^<%s]+)")
        if class_part then
          -- Prepend this class/module part to the growing fully qualified name.
          fully_qualified = class_part .. suffix .. fully_qualified
          suffix = "::"  -- after the first, we switch to '::'
          current_indent = indent
        end
      end
    end

    line_index = line_index - 1
  end

  -- 5. Yank the final result to the default register.
  vim.fn.setreg('"', fully_qualified)

  -- Optionally, display a message to confirm.
  print("Yanked: " .. fully_qualified)
end

-- Example:
--
--     module Foo
--       class Bar
--         def self.baz
--                  # ^ cursor here
--
-- Pressing <leader>ym will yank "Foo::Bar.baz".
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.keymap.set(
      "n",
      "<leader>ym",
      function()
        M.yank_fully_qualified_method_name()
      end,
      { noremap = true, silent = true, buffer = true }
    )
  end,
})
