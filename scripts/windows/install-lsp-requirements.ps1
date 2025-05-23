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
    "@stoplight/spectral-cli",
    "yaml-language-server"
    # "@ansible/ansible-language-server",
    # "css-language-server",
    # "cssmodules-language-server",
    # "eslint",
    # "@bmewburn/vscode-html-languageserver",
    # "@aws/lsp-json",
    # "sql-language-server",
    # "svelte-language-server"
)

$PythonDependencies = @(
    "nginx-language-server",
    "ruff",
    "ruff-lsp",
    "salt-lsp",
    "sqruff",
    "cmake-language-server"
)

if ( Get-Command "uv" ) {
    Write-Host "Using uv for Python dependencies"
    $PythonPkgManager = "uv"
} else {
    Write-Host "Using pip for Python dependencies"
    $PythonPkgManager = "pip"
}


## Install node dependencies
foreach ($NpmPkg in $NpmDependencies ) {
    try {
        npm install -g $NpmPkg
    } catch {
        Write-Error "Error installing NPM dependency '$NpmPkg'. Details: $($Exception.Message)"
    }
}

## Install python dependencies
foreach ($PythonPkg in $PythonDependencies ) {
    if ($PythonPkgManager -eq "uv") {
        try {
            uv tool install $PythonPkg
        } catch {
            Write-Error "Error installing Python dependency '$PythonPkg'. Details: $($Exception.Message)"
        }
    } else {
        try {
            python -m pip install $PythonPkg
        } catch {
            Write-Error "Error installing Python dependency '$PythonPkg'. Details: $($Exception.Message)"
        }
    }
}