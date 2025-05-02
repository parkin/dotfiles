-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.scrolloff = 12

-- Clipboard options, only for my WSL
if vim.fn.hostname() == "wsl-nixos" then
  if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
      name = "WslClipboard",
      -- need to explicitly set clip as the copy utility here
      copy = {
        ["+"] = "/mnt/c/Windows/System32/clip.exe",
        ["*"] = "/mnt/c/Windows/System32/clip.exe",
      },
      -- paste = {
      --   ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      --   ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      -- },
      cache_enabled = 0,
    }
  end
end
