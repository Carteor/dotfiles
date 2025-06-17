local Terminal = require('toggleterm.terminal').Terminal

-- Define a persistent terminal instance
local python_term = Terminal:new {
  direction = 'vertical',
  size = 80,
  hidden = true, -- Keeps it from being automatically visible
}

vim.keymap.set('n', '<F5>', function()
  local file = vim.fn.expand '%:p' -- Get full path of the current file
  if file == '' then
    print 'No file name found!' -- Prevents errors when no file is open
    return
  end

  -- Open the terminal if it's not already open
  if not python_term:is_open() then
    python_term:toggle()
  end

  -- Send the Python command to the terminal
  python_term:send('python3 ' .. file, true)
end, { noremap = true, silent = true })
