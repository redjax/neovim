return {
  name = "docker",
  servers = { "dockerls", "docker_compose_language_service" },
  tools = { "dockerfile-language-server", "docker-compose-language-service", "hadolint" },
  settings = {
    dockerls = {
      settings = {
        docker = {
          languageserver = {
            formatter = {
              ignoreMultilineInstructions = false,  -- Enable multi-line formatting
            },
            diagnostics = {
              -- Enable additional diagnostics
              deprecatedMaintainer = true,
              directiveCasing = true,
              emptyContinuationLine = true,
              instructionCasing = "uppercase",  -- Enforce uppercase instructions
              instructionCmdMultiple = true,
              instructionEntrypointMultiple = true,
              instructionHealthcheckMultiple = true,
              instructionJSONInSingleQuotes = true,
              instructionWorkdirRelative = true,
            },
          },
        },
      },
    },
    docker_compose_language_service = {
      -- Docker Compose LSP settings
      settings = {
        compose = {
          -- Enable validation and completion
          validation = true,
          completion = true,
          hover = true,
        },
      },
    },
  },
  filetypes = { "dockerfile", "yaml.docker-compose" },
}