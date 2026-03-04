-- Override nvim-autopairs configuration
-- Disable auto-closing single quotes to prevent issues with contractions

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = function(_, opts)
    -- Return empty opts, we'll configure in the config function
    return opts or {}
  end,
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)
    
    -- Remove the default single quote rule after setup
    npairs.remove_rule("'")
    
    -- Don't auto-close single quotes (prevents issues with contractions like don't, can't, etc.)
    -- You can still manually type '' when you need string literals
  end,
}
