$NpmDependencies = @(
    "neovim",
    "gh-actions-language-server",
    "azure-pipelines-language-server",
    "bash-language-server",
    "css-variables-language-server",
    "@microsoft/compose-language-service",
    "dockerfile-language-server-nodejs",
    "graphql-language-service-cli",
    "pyright",
    "@stoplight/spectral-cli"
)

foreach ($NpmPkg in $NpmDependencies ) {
    try {
        npm install -g $NpmPkg
    } catch {
        Write-Error "Error installing NPM dependency '$NpmPkg'. Details: $($Exception.Message)"
    }
}
