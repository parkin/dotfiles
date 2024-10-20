return {
  -- "hkupty/iron.nvim", -- This is the original
  "frere-jacques/iron.nvim",
  branch = "feature_send_code_block", -- This is a fork that added code block running
  init = function()
    local iron = require("iron.core")

    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "zsh" },
          },
          python = {
            -- command = { "python3" }, -- or { "ipython", "--no-autoindent" }
            command = { "jupyter-console" },
            format = require("iron.fts.common").bracketed_paste_python,
            block_deviders = { "# %%", "#%%" },
          },
        },
        -- How the repl window will be displayed
        -- See below for more information
        -- repl_open_cmd = require("iron.view").bottom(40),
        repl_open_cmd = "vertical botright 80 split",
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        send_motion = "<space>ic",
        visual_send = "<space>ic",
        send_file = "<space>if",
        send_line = "<space>il",
        send_paragraph = "<space>ip",
        send_until_cursor = "<space>iu",
        send_mark = "<space>im",
        send_code_block = "<space>ib",
        send_code_block_and_move = "<space>in",
        mark_motion = "<space>imc",
        mark_visual = "<space>imc",
        remove_mark = "<space>imd",
        cr = "<space>i<cr>",
        interrupt = "<space>i<space>",
        exit = "<space>iq",
        clear = "<space>icl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<cr>")
    vim.keymap.set("n", "<space>rr", "<cmd>IronRestart<cr>")
    vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
  end,
}
