-- Override nvim-autopairs configuration
-- Disable auto-closing single quotes to prevent issues with contractions

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = function(_, opts)
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    
    -- Remove the default single quote rule
    npairs.remove_rule("'")
    
    -- Don't auto-close single quotes (prevents issues with contractions like don't, can't, etc.)
    -- You can still manually type '' when you need string literals
    
    return opts
  end,
}
