return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
    build = ":UpdateRemotePlugins",
    init = function()
      -- this is an example, not a default. Please see the readme for more configuration options
      vim.g.molten_output_win_max_height = 12
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
        "]h",
        function()
          require("notebook-navigator").move_cell("d")
        end,
      },
      {
        "[h",
        function()
          require("notebook-navigator").move_cell("u")
        end,
      },
      { "<leader>mc", "<cmd>lua require('notebook-navigator').run_cell()<cr>" },
      { "<leader>mn", "<cmd>lua require('notebook-navigator').run_and_move()<cr>" },
      { "<leader>mA", "<cmd>lua require('notebook-navigator').run_cells_above()<cr>" },
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
