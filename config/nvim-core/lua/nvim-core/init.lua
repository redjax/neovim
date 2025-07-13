-- Detect platform
local platform = require("nvim-core.config.platform")

require("nvim-core.config")

-- Return platform so it can be used in other configs
return { platform = platform }
