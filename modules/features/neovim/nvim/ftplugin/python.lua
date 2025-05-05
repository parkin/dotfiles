-- [[
-- Keymaps for python
-- ]]

-- These keymaps jump to the next code cell, # %%
vim.keymap.set(
  { "n", "v" },
  "]b",
  -- / - forward
  -- ^ - beginning of line
  -- [ \\t]* any number of spaces or tabs
  -- #\\s8%% - # %% with any number of spaces between
  "/^[ \\t]*#\\s*%%<CR><Cmd>nohlsearch<CR>",
  { desc = "Move to next code block", noremap = true, silent = true, buffer = true }
)
vim.keymap.set(
  { "n", "v" },
  "[b",
  "?^[ \\t]*#\\s*%%<CR><Cmd>nohlsearch<CR>",
  { desc = "Move to next code block", noremap = true, silent = true, buffer = true }
)
