-- SQLite.lua https://github.com/kkharji/sqlite.lua

return {
    "kkharji/sqlite.lua",
    lazy = true,
    -- No config needed for basic use; plugins will require it as a dependency
    -- If you want to eagerly load it for development/testing, set lazy = false
    -- If you need to specify the SQLite DLL path on Windows, see below
    init = function()
      -- Windows users: Uncomment and set the path to your sqlite3.dll if needed
      -- vim.g.sqlite_clib_path = "C:/path/to/sqlite3.dll"
    end,
  }
  