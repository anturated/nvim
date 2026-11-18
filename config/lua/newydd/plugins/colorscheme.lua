return {
  {
    "evergarden-nvim",
    priority = 1000,
    after = function()
      local evergarden = require("evergarden")
      local accent_file = vim.fn.stdpath("data") .. "/newydd_accent"

      local function save_accent(accent)
        local f = io.open(accent_file, "w")
        if f then
          f:write(accent)
          f:close()
        end
      end

      local function load_accent()
        local f = io.open(accent_file, "r")
        if f then
          local accent = f:read("*l")
          f:close()
          return accent
        end
      end

      local opts = {
        editor = { transparent_background = true },
        theme = {
          variant = "winter",
          accent = "lime",
        },
        color_overrides = {},
      }

      -- evergarden only accepts palette names as accent, so a hex gets
      -- injected into the palette under a custom key and the accent points at it
      local custom_key = "newydd_custom"

      local function apply_accent(accent)
        accent = vim.trim(accent or "")
        if accent == "" then
          return false
        end

        if accent:sub(1, 1) == "#" then
          if not accent:match("^#%x%x%x%x%x%x$") then
            vim.notify("Invalid hex color: " .. accent, vim.log.levels.ERROR)
            return false
          end
          opts.color_overrides = { [custom_key] = accent }
          opts.theme.accent = custom_key
        else
          opts.color_overrides = {}
          opts.theme.accent = accent
        end

        evergarden.setup(opts)
        vim.cmd.colorscheme("evergarden")
        return true
      end

      local current = load_accent() or "lime"
      if not apply_accent(current) then
        apply_accent("lime")
      end

      -- hot reload: re-apply whenever the accent file changes on disk
      -- (e.g. `echo '#ff8800' > ~/.local/share/nvim/newydd_accent`)
      local watcher = vim.uv.new_fs_event()
      if watcher then
        local function on_change()
          local accent = load_accent()
          if accent and vim.trim(accent) ~= current then
            current = vim.trim(accent)
            apply_accent(current)
          end
        end

        local function watch()
          -- watch the directory, since editors/shell redirects may replace the file
          watcher:start(vim.fn.fnamemodify(accent_file, ":h"), {}, function(err, fname)
            if err then
              return
            end
            if fname == vim.fn.fnamemodify(accent_file, ":t") then
              vim.schedule(on_change)
            end
          end)
        end
        watch()
      end

      vim.api.nvim_create_user_command("NewyddAccent", function(opts_)
        local accent = vim.trim(opts_.args)
        if not apply_accent(accent) then
          return
        end
        current = accent
        save_accent(accent)
        vim.notify("Switched accent to " .. accent)
      end, {
        nargs = 1,
        complete = function()
          return {
            "red",
            "orange",
            "yellow",
            "lime",
            "green",
            "aqua",
            "skye",
            "snow",
            "blue",
            "purple",
            "pink",
            "cherry",
            -- i mean these exist but autocomplete clutter
            -- "text", "subtext1", "subtext0", "overlay2", "overlay1", "overlay0",
            -- "surface2", "surface1", "surface0", "base", "mantle", "crust",
          }
        end,
        desc = "Set colorscheme accent",
      })
    end,
  },

  {
    "nightfox.nvim",

    after = function()
      local opts = {
        options = {
          transparent = true,
        },
      }

      require("nightfox").setup(opts)
    end,
  },
}
