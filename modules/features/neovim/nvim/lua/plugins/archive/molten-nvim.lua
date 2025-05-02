-- archive
if true then
  return {}
end
--

return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
      -- disable auto ouput (hoping this speeds things up?)
      vim.g.molten_auto_open_output = false
      -- keymaps
      vim.keymap.set("n", "<localleader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
      vim.keymap.set("n", "<localleader>ml", ":MoltenEvaluateLine<CR>", { silent = true, desc = "evaluate line" })
      vim.keymap.set("n", "<localleader>mr", ":MoltenReevaluateCell<CR>", { silent = true, desc = "re-evaluate cell" })
      vim.keymap.set(
        "v",
        "<localleader>mv",
        ":<C-u>MoltenEvaluateVisual<CR>gv",
        { silent = true, desc = "evaluate visual selection" }
      )
      vim.keymap.set("n", "<localleader>moh", ":MoltenHideOutput<CR>", { silent = true, desc = "hide output" })
      vim.keymap.set(
        "n",
        "<localleader>mos",
        ":noautocmd MoltenEnterOutput<CR>",
        { silent = true, desc = "show/enter output" }
      )
    end,
  },
  {
    -- this is the original
    -- "GCBallesteros/NotebookNavigator.nvim",
    -- this is a fork that adds run_cells_above
    "ESSO0428/NotebookNavigator.nvim",
    branch = "FOR_PR_README",
    keys = {
      {
        "]x",
        function()
          require("notebook-navigator").move_cell("d")
        end,
        desc = "next cell NotebookNavigator",
      },
      {
        "[x",
        function()
          require("notebook-navigator").move_cell("u")
        end,
        desc = "prev cell NotebookNavigator",
      },
      { "<localleader>mc", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
      { "<localleader>mn", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
      { "<localleader>mA", "<cmd>lua require('notebook-navigator').run_cells_above()<cr>" },
    },
    dependencies = {
      "echasnovski/mini.comment",
      -- "hkupty/iron.nvim", -- repl provider
      -- "akinsho/toggleterm.nvim", -- alternative repl provider
      "benlubas/molten-nvim", -- alternative repl provider
      "anuvyklack/hydra.nvim",
    },
    event = "VeryLazy",
    config = function()
      local nn = require("notebook-navigator")
      nn.setup({
        activate_hydra_keys = "<leader>h",
        repl_provider = "molten",
      })
    end,
  },
}
