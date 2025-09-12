## Define NPM dependencies
$NpmDependencies = @(
    "alex",
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
    "yaml-language-server",
    "markdownlint",
    "markdownlint-cli2",
    "prettier",
    "stylelint",
    "write-good",
    "sql-formatter"
    # "@ansible/ansible-language-server",
    # "css-language-server",
    # "cssmodules-language-server",
    # "eslint",
    # "@bmewburn/vscode-html-languageserver",
    # "@aws/lsp-json",
    # "sql-language-server",
    # "svelte-language-server"
)

## Define Python dependencies
$PythonDependencies = @(
    "pyyaml",
    "nginx-language-server",
    "pynvim",
    "ruff",
    "ruff-lsp",
    "salt-lsp",
    "sqruff",
    "cmake-language-server",
    "mdformat",
    "ansible-lint",
    "yamlfix",
    "sqlfmt",
    "sqlformat"
)

## Define Python tools (installed with uv tool install or pipx)
$PythonToolDependencies = @()

## Define Rust/Cargo dependencies
$CargoDependencies = @(
    "stylua"
)

## Define Go dependencies
$GoDependencies = @(
    "mvdan.cc/sh/v3/cmd/shfmt@latest",
    "github.com/rhysd/actionlint/cmd/actionlint@latest",
    "github.com/incu6us/goimports-reviser/v3@latest",
    "github.com/google/yamlfmt/cmd/yamlfmt@latest"
)

if ( Get-Command "uv" ) {
    Write-Host "Using uv for Python dependencies"
    $PythonPkgManager = "uv"
    $PythonToolManager = "uv"
}
else {
    Write-Host "Using pip for Python dependencies"
    $PythonPkgManager = "pip"
    $PythonToolManager = "pipx"
}

## Install node dependencies
if ( Get-Command "npm" -ErrorAction SilentlyContinue ) {
    foreach ($NpmPkg in $NpmDependencies ) {
        try {
            npm install -g $NpmPkg
        }
        catch {
            Write-Error "Error installing NPM dependency '$NpmPkg'. Details: $($Exception.Message)"
        }
    }
}
else {
    Write-Warning "NPM is not installed. Please install Node.js and NPM before running this script."
    exit 1
}

## Install Python tools
if ( Get-Command $PythonToolManager -ErrorAction SilentlyContinue ) {
    foreach ($PythonToolPkg in $PythonToolDependencies ) {
        if ($PythonToolManager -eq "uv") {
            try {
                uv tool install $PythonToolPkg
            }
            catch {
                Write-Error "Error installing Python tool dependency '$PythonToolPkg'. Details: $($Exception.Message)"
            }
        }
        else {
            if ( -not ( Get-Command "pipx" -ErrorAction SilentlyContinue ) ) {
                Write-Warning "pipx is not installed. Installing now"
                if ($PythonPkgManager -eq "uv") {
                    uv tool install pipx
                }
                else {
                    python -m pip install --user pipx
                    python -m pipx ensurepath
                    $env:Path += ";$([System.Environment]::GetFolderPath('UserProfile'))\.local\bin"
                }
            }
            try {
                pipx install $PythonToolPkg
            }
            catch {
                Write-Error "Error installing Python tool dependency '$PythonToolPkg'. Details: $($Exception.Message)"
                Write-Host "Retrying $PythonToolPkg install with pipx"

                pipx install $PythonToolPkg
            }
        }
    }
}
else {
    Write-Warning "$PythonToolManager is not installed. Please install Python and pipx before running this script."
    exit 1
}

## Install Python dependencies
if ( Get-Command $PythonPkgManager -ErrorAction SilentlyContinue ) {
    foreach ($PythonPkg in $PythonDependencies ) {
        if ($PythonPkgManager -eq "uv") {
            try {
                uv tool install $PythonPkg
            }
            catch {
                Write-Error "Error installing Python dependency '$PythonPkg'. Details: $($Exception.Message)"
            }
        }
        else {
            try {
                python -m pip install $PythonPkg
            }
            catch {
                Write-Error "Error installing Python dependency '$PythonPkg'. Details: $($Exception.Message)"
                Write-Host "Retrying $PythonPkg install with python -m pip"

                python -m pip install $PythonPkg
            }
        }
    }
}
else {
    Write-Warning "$PythonPkgManager is not installed. Please install Python and pip before running this script."
    exit 1
}

## Install Go dependencies
if ( Get-Command "go" -ErrorAction SilentlyContinue ) {
    foreach ($GoPkg in $GoDependencies ) {
        try {
            go install $GoPkg
        }
        catch {
            Write-Error "Error installing Go dependency '$GoPkg'. Details: $($Exception.Message)"
        }
    }
}
else {
    Write-Warning "Go is not installed. Please install Go before running this script."
    exit 1
}

## Install Rust/Cargo dependencies
if ( Get-Command "cargo" -ErrorAction SilentlyContinue ) {
    foreach ($CargoPkg in $CargoDependencies ) {
        try {
            cargo install $CargoPkg
        }
        catch {
            Write-Error "Error installing Cargo dependency '$CargoPkg'. Details: $($Exception.Message)"
        }
    }
}
else {
    Write-Warning "Cargo is not installed. Please install Rust and Cargo before running this script."
    exit 1
}
