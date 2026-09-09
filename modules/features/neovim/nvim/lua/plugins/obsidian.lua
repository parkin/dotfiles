-- Mirrors the real vault config in ~/git/wiki/.obsidian
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

    -- app.json: newFileLocation = "folder", newFileFolderPath = "wiki"
    notes_subdir = "wiki",
    new_notes_location = "notes_subdir",

    -- Obsidian names notes after their title verbatim (e.g. "Ali Bagherian.md"),
    -- falling back to a zettel timestamp when there's no title.
    note_id_func = function(title)
      if title ~= nil and title ~= "" then
        return title
      end
      return tostring(os.date "%Y%m%d%H%M")
    end,

    -- app.json: alwaysUpdateLinks = true
    link = {
      style = "wiki",
      auto_update = true,
    },

    -- Vault notes carry only `date_created` and optional `aliases` in frontmatter;
    -- tags and status live inline in the body, and there is no `id` property.
    frontmatter = {
      sort = { "date_created", "aliases" },
      func = function(note)
        local out = {}
        if note.metadata ~= nil then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        if out.date_created == nil then
          out.date_created = os.date "%Y-%m-%d %H:%M"
        end
        if #note.aliases > 0 then
          out.aliases = note.aliases
        end
        return out
      end,
    },

    -- templates.json: folder = "Templates"
    templates = {
      folder = "Templates",
      date_format = "YYYY-MM-DD",
      time_format = "HH:mm",
    },

    -- Shape new notes like the vault's "New Note" template.
    note = {
      template = "New Note.md",
    },

    -- daily-notes.json: folder = "Journal", template = "Templates/Journal Entry"
    -- NOTE: that template is written for Templater (`<% tp.* %>`), which
    -- obsidian.nvim does not expand — those lines land verbatim.
    daily_notes = {
      folder = "Journal",
      date_format = "YYYY-MM-DD",
      template = "Journal Entry.md",
      default_tags = {},
      workdays_only = false,
    },

    -- zk-prefixer.json: folder = "Fleeting", template = "Templates/Fleeting Note"
    unique_note = {
      folder = "Fleeting",
      format = "YYYYMMDDHHmm",
      template = "Fleeting Note.md",
    },

    -- app.json: attachmentFolderPath = "assets"
    attachments = {
      folder = "assets",
    },

    -- `wiki-backup/` is a full snapshot of the vault; only the live notes
    -- should show up in search, completion and backlinks.
    file = {
      ignore_filters = { "wiki-backup/" },
    },
  },
}
