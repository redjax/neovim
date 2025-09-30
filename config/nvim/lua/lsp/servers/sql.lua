return {
  name = "sql",
  servers = { "sqlls", "sqls" },
  tools = { "sqlls", "sqls" },
  settings = {
    sqlls = {
      connections = {
        {
          driver = "postgresql",
          dataSourceName = "host=127.0.0.1 port=5432 user=postgres password= dbname=postgres sslmode=disable",
        },
        {
          driver = "mysql",
          dataSourceName = "root:password@tcp(127.0.0.1:3306)/",
        },
        {
          driver = "sqlserver",
          dataSourceName = "sqlserver://username:password@localhost/instance?database=dbname",
        },
      },
    },
    sqls = {
      connections = {
        {
          driver = "postgresql",
          dataSourceName = "host=127.0.0.1 port=5432 user=postgres password= dbname=postgres sslmode=disable",
        },
        {
          driver = "mysql",
          dataSourceName = "root:password@tcp(127.0.0.1:3306)/",
        },
        {
          driver = "mssql",
          dataSourceName = "sqlserver://username:password@localhost/instance?database=dbname",
        },
      },
    },
  },
  filetypes = { "sql", "mysql", "plsql" },
}