if true then
  return {}
end
-- currently disables other completion sources
-- submitted issue https://github.com/SUSTech-data/neopyter/issues/16
return {
  {
    "SUSTech-data/neopyter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "AbaoFromCUG/websocket.nvim",
    },
    ---@type neopyter.Option
    opts = {
      mode = "direct",
      remote_address = "127.0.0.1:9001",
      file_pattern = { "*.ju.*" },
      on_attach = function(buf)
        -- Keymaps --------------------------------------------
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, buffer = buf })
        end
        -- same, recommend the former
        map("n", "<localleader>nc", "<cmd>Neopyter execute notebook:run-cell<cr>", "run selected")
        -- map("n", "<C-Enter>", "<cmd>Neopyter run current<cr>", "run selected")

        -- same, recommend the former
        map("n", "<localleader>nA", "<cmd>Neopyter execute notebook:run-all-above<cr>", "run all above cell")
        -- map("n", "<space>X", "<cmd>Neopyter run allAbove<cr>", "run all above cell")

        -- same, recommend the former, but the latter is silent
        map("n", "<localleader>nr", "<cmd>Neopyter execute kernelmenu:restart<cr>", "restart kernel")
        -- map("n", "<space>nt", "<cmd>Neopyter kernel restart<cr>", "restart kernel")

        map("n", "<localleader>nn", "<cmd>Neopyter execute runmenu:run<cr>", "run selected and select next")
        map(
          "n",
          "<localleader>nN",
          "<cmd>Neopyter execute run-cell-and-insert-below<cr>",
          "run selected and insert below"
        )

        map("n", "<localleader>nR", "<cmd>Neopyter execute notebook:restart-run-all<cr>", "restart kernel and run all")

        -- nvim-cmp --------------------------------------------
        local lspkind = require("lspkind")
        local cmp = require("cmp")
      end,
      highlight = {
        enable = true,
        shortsighted = false,
      },
      parser = {
        -- trim leading/tailing whitespace of cell
        trim_whitespace = false,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "SUSTech-data/neopyter",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local lspkind = require("lspkind")
      table.insert(opts.sources, { name = "neopyter" })
      table.insert(opts.formatting, {
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              neopyter = "[Neopyter]",
            },
            symbol_map = {
              -- specific complete item kind icon
              ["Magic"] = "🪄",
              ["Path"] = "📁",
              ["Dict key"] = "🔑",
              ["Instance"] = "󱃻",
              ["Statement"] = "󱇯",
            },
          }),
        },
      })
    end,
  },
  -- {
  --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "onsails/lspkind.nvim",
  --   },
  --   opts = function(_, opts)
  --     table.insert(opts.sources, { name = "neopyter" })
  --   end,
  -- },
}
