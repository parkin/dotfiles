return {
  "obsidian-nvim/obsidian.nvim",
  version = "v3.16.6", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0
    workspaces = {
      {
        name = "wiki",
        path = "~/git/wiki",
      },
    },
  },
}
