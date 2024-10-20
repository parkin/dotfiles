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
            command = {
              "jupyter-console",
              -- "--existing",
              "--ZMQTerminalInteractiveShell.image_handler=None",
            },
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
        send_motion = "<leader>ic",
        visual_send = "<leader>ic",
        send_file = "<leader>if",
        send_line = "<leader>il",
        send_paragraph = "<leader>ip",
        send_until_cursor = "<leader>iu",
        send_mark = "<leader>im",
        send_code_block = "<leader>ib",
        send_code_block_and_move = "<leader>in",
        mark_motion = "<leader>imc",
        mark_visual = "<leader>imc",
        remove_mark = "<leader>imd",
        cr = "<leader>i<cr>",
        interrupt = "<leader>i<leader>",
        exit = "<leader>iq",
        clear = "<leader>icl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set("n", "<leader>ii", "<cmd>IronRepl<cr>")
    vim.keymap.set("n", "<leader>ir", "<cmd>IronRestart<cr>")
    vim.keymap.set("n", "<leader>if", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<leader>ih", "<cmd>IronHide<cr>")
  end,
}
