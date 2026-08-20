return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    local actions = require("fzf-lua.actions")
    local toggle_hidden = { fn = actions.toggle_hidden, reuse = true }

    -- move toggle_hidden off alt-h (kept free for window navigation) onto alt-s
    local function remap(tbl)
      tbl["alt-h"] = false
      tbl["alt-s"] = toggle_hidden
    end

    -- global file actions, inherited by every file/grep-like picker.
    -- `[1] = true` tells fzf-lua to still inherit its default binds
    opts.actions = opts.actions or {}
    opts.actions.files = vim.tbl_extend("force", { [1] = true }, opts.actions.files or {})
    remap(opts.actions.files)

    -- LazyVim sets these per-picker, so they need overriding too
    for _, picker in ipairs({ "files", "grep" }) do
      if opts[picker] and opts[picker].actions then
        remap(opts[picker].actions)
      end
    end

    return opts
  end,
}
