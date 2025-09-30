-- SQL Language Server configuration
-- Supports multiple SQL database types

return {
  name = "sql",
  servers = { "sqlls" },
  config = function()
    return {
      sqlls = {
        filetypes = { "sql", "mysql", "pgsql", "plsql" },
        settings = {
          sqlLanguageServer = {
            connections = {
              -- Add your database connections here
              -- Example for PostgreSQL:
              -- {
              --   name = "postgres_local",
              --   adapter = "postgresql", 
              --   host = "localhost",
              --   port = 5432,
              --   user = "postgres",
              --   database = "mydb"
              -- }
            },
          },
        },
      }
    }
  end,
}