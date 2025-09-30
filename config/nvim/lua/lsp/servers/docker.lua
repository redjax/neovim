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
              ignoreMultilineInstructions = true,
            },
          },
        },
      },
    },
    docker_compose_language_service = {
      -- Docker Compose LSP settings
      settings = {},
    },
  },
  filetypes = { "dockerfile", "docker-compose" },
}