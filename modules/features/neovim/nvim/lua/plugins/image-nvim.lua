return {
  "3rd/image.nvim",
  event = "VeryLazy",
  opts = {
    backend = "sixel",
    -- lua51Packages.magick (magick_rock) is marked broken in nixpkgs, so we use
    -- magick_cli. The flakiness is managed via a CursorMoved debounce below.
    processor = "magick_cli",
    integrations = {
      markdown = {
        enabled = true,
        only_render_image_at_cursor = true,
        -- Don't clear the image every time you enter insert mode; the sixel redraw
        -- on re-entry is one of the main flicker sources.
        clear_in_insert_mode = false,
        filetypes = { "markdown" },
      },
    },
    -- Use percentage-based sizing instead of fixed cells (10 cells is far too small
    -- and causes constant re-renders). Hard cell limits are left as a safety cap.
    max_width = 80,
    max_height = 40,
    max_width_window_percentage = 50,
    max_height_window_percentage = 40,
    -- Disabling overlap clearing reduces aggressive redraws where every focus event
    -- would otherwise trigger a full sixel flush.
    window_overlap_clear_enabled = false,
    editor_only_render_when_focused = true,
    -- "inline" is more stable than "popup" (popup creates a floating window whose
    -- position changes on every CursorMoved, triggering a fresh magick_cli spawn).
    only_render_image_at_cursor_mode = "inline",
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  },
  config = function(_, opts)
    require("image").setup(opts)

    -- Debounce CursorMoved so we only fire a magick_cli render after the cursor
    -- has been still for 150 ms. Without this, every keystroke/scroll spawns a
    -- new ImageMagick subprocess on WSL, queuing up overlapping renders that
    -- corrupt the sixel output and appear as flicker.
    local timer = vim.uv.new_timer()
    local api = require("image")

    vim.api.nvim_create_autocmd("CursorMoved", {
      callback = function()
        timer:stop()
        timer:start(
          300,
          0,
          vim.schedule_wrap(function()
            -- render_image_at_cursor is the internal method image.nvim uses when
            -- only_render_image_at_cursor = true; calling it here replaces the
            -- built-in immediate handler with our debounced one.
            pcall(api.render_image_at_cursor)
          end)
        )
      end,
    })
  end,
}
