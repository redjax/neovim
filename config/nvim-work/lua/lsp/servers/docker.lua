-- Docker Language Server configuration
-- Supports Dockerfile LSP and linting

return {
  name = "docker",
  servers = { "dockerls" },
  config = function()
    return {
      dockerls = {
        filetypes = { "dockerfile", "Dockerfile" },  -- Support both cases
        settings = {
          docker = {
            languageserver = {
              formatter = {
                ignoreMultilineInstructions = true,
              },
            },
          },
        },
      }
    }
  end,
}