-- Videre https://github.com/Owen-Dechow/videre.nvim

return {
  "Owen-Dechow/nvim_json_graph_view",
  dependencies = {
    "Owen-Dechow/graph_view_yaml_parser", -- Optional YAML support
    "Owen-Dechow/graph_view_toml_parser", -- Optional TOML support
    "a-usr/xml2lua.nvim", -- Optional experimental XML support
  },
  opts = {
    round_units = false,
  },
}
