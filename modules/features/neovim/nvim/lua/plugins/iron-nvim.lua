-- add an AI group to which-key
local wk = require("which-key")
wk.add({
  { "<leader>i", group = "+Iron REPL" }, -- group
})

return {
  -- "hkupty/iron.nvim", -- This is the original
  "Vigemus/iron.nvim",
  -- "frere-jacques/iron.nvim",
  -- branch = "feature_send_code_block", -- This is a fork that added code block running
  init = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

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
            -- return the best console available in the path
            command = function()
              if vim.fn.executable("jupyter-console") == 1 then
                return {
                  "jupyter-console",
                  -- "--existing",
                  "--ZMQTerminalInteractiveShell.image_handler=None",
                }
              elseif vim.fn.executable("ipython") == 1 then
                return { "ipython", "--no-autoindent" }
              else
                return { "python3" }
              end
            end,
            -- format = common.bracketed_paste_python, -- <-- note this doesn't work well, it tries to run a code block one line at a time
            format = common.bracketed_paste, -- <-- this works much better, runs the whole code block at once
            block_dividers = { "# %%", "#%%" },
          },
        },
        -- set the file type of the newly created repl to ft
        -- bufnr is the buffer id of the REPL and ft is the filetype of the
        -- language being used for the REPL.
        repl_filetype = function(bufnr, ft)
          return ft
          -- or return a string name such as the following
          -- return "iron"
        end,
        -- How the repl window will be displayed
        repl_open_cmd = view.split.vertical.botright(0.4, {
          winfixwidth = false,
          winfixheight = false,
          -- any window-local configuration can be used here
          number = true,
        }),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        toggle_repl = "<space>ir", -- toggles the repl open and closed.
        -- If repl_open_command is a table as above, then the following keymaps are
        -- available
        -- toggle_repl_with_cmd_1 = "<space>rv",
        -- toggle_repl_with_cmd_2 = "<space>rh",
        restart_repl = "<space>iR", -- calls `IronRestart` to restart the repl
        send_motion = "<space>ic",
        visual_send = "<space>iv",
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
        cr = "<space>s<cr>",
        interrupt = "<space>ii",
        exit = "<space>iq",
        clear = "<space>ix",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    })

    -- iron also has a list of commands, see :h iron-commands for all available commands
    vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
    vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")
  end,
}
