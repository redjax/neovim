Set-StrictMode -Version 3.0

. (Join-Path $PSScriptRoot 'Common.ps1')

function Install-Scoop {
    [CmdletBinding()]
    param([switch]$DryRun)

    if (Test-CommandAvailable -Name 'scoop') {
        return
    }

    if ($DryRun) {
        Write-DryRun "Would install scoop"
        return
    }

    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

function Initialize-Scoop {
    [CmdletBinding()]
    param([switch]$DryRun)

    if ($DryRun) {
        Write-DryRun "Would install aria2"
        Write-DryRun "Would configure scoop and add buckets"
        return
    }

    scoop install aria2
    scoop config aria2-enabled true
    scoop config aria2-warning-enabled false

    foreach ($bucket in @('extras', 'nerd-fonts')) {
        scoop bucket add $bucket 2>$null
    }
}

function Install-ScoopPackages {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$Packages,

        [switch]$DryRun
    )

    foreach ($pkg in $Packages) {
        if ($DryRun) {
            Write-DryRun "Would install scoop package '$pkg'"
            continue
        }

        if (scoop list $pkg 2>$null) {
            Write-Host "Skipping scoop package (already installed): $pkg"
            continue
        }

        Write-Host "Installing scoop package: $pkg"
        try {
            scoop install $pkg
        }
        catch {
            Write-Warning "Failed to install '$pkg': $($_.Exception.Message)"
        }
    }
}

function Install-NeovimWindowsDependencies {
    [CmdletBinding()]
    param([switch]$DryRun)

    $dependencies = @(
        'win32yank',
        'nodejs-lts',
        'fzf',
        'tree-sitter',
        'ripgrep',
        'FiraCode-NF',
        'FiraCode-NF-Mono',
        'cmake',
        'gcc',
        'lua',
        'luarocks',
        'python',
        'curl',
        'unzip',
        'lua-for-windows',
        'make',
        'wget',
        'gzip',
        'fd',
        'sed'
    )

    Install-Scoop -DryRun:$DryRun
    Initialize-Scoop -DryRun:$DryRun
    Install-ScoopPackages -Packages $dependencies -DryRun:$DryRun

    if (-not (Test-CommandAvailable -Name 'nvim')) {
        if ($DryRun) {
            Write-DryRun "Would install neovim with scoop"
        }
        else {
            scoop install neovim
        }
    }
}

function Test-NpmGlobalPackageInstalled {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$PackageName
    )

    if (-not (Test-CommandAvailable -Name 'npm')) {
        return $false
    }

    $npmRoot = npm root -g 2>$null
    if ([string]::IsNullOrWhiteSpace($npmRoot)) {
        return $false
    }

    Test-Path -LiteralPath (Join-Path $npmRoot $PackageName)
}

function Install-MissingNpmGlobalPackages {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$Packages
    )

    $missing = New-Object System.Collections.Generic.List[string]

    foreach ($pkg in $Packages) {
        if (Test-NpmGlobalPackageInstalled -PackageName $pkg) {
            Write-Host "Skipping NPM package (already installed): $pkg"
            continue
        }

        $missing.Add($pkg)
    }

    if ($missing.Count -eq 0) {
        Write-Host 'All requested NPM packages are already installed'
        return
    }

    npm install -g @($missing)
}

function Install-TreeSitterCli {
    [CmdletBinding()]
    param([switch]$Force)

    if ((-not $Force) -and (Test-CommandAvailable -Name 'tree-sitter')) {
        Write-Host "tree-sitter already installed: $(tree-sitter --version)"
        return
    }

    $installDir = Join-Path $env:LOCALAPPDATA 'bin'
    if (-not (Test-Path -LiteralPath $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    $arch = [System.Runtime.InteropServices.RuntimeInformation]::ProcessArchitecture
    $gitHubArch = switch ($arch) {
        'X64' { 'x86_64' }
        'Arm64' { 'aarch64' }
        default { '' }
    }

    if (-not [string]::IsNullOrWhiteSpace($gitHubArch)) {
        try {
            $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest'
            $downloadUrl = ($release.assets | Where-Object { $_.name -match "windows-$gitHubArch\.zip" } | Select-Object -First 1).browser_download_url

            if ($downloadUrl) {
                $tempZip = Join-Path $env:TEMP 'tree-sitter.zip'
                $tempDir = Join-Path $env:TEMP 'tree-sitter-extract'

                Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -ErrorAction Stop

                if (Test-Path -LiteralPath $tempDir) {
                    Remove-Item -LiteralPath $tempDir -Recurse -Force
                }

                Expand-Archive -Path $tempZip -DestinationPath $tempDir -Force
                $exe = Get-ChildItem -Path $tempDir -Filter 'tree-sitter.exe' -Recurse | Select-Object -First 1
                if ($exe) {
                    Copy-Item -Path $exe.FullName -Destination (Join-Path $installDir 'tree-sitter.exe') -Force
                    Add-UserPathEntry -PathEntry $installDir

                    if (Test-CommandAvailable -Name 'tree-sitter') {
                        Write-Host "tree-sitter installed from GitHub: $(tree-sitter --version)"
                        Remove-Item -LiteralPath $tempZip -Force -ErrorAction SilentlyContinue
                        Remove-Item -LiteralPath $tempDir -Recurse -Force -ErrorAction SilentlyContinue
                        return
                    }
                }
            }
        }
        catch {
            Write-Warning "GitHub installation failed, falling back to npm. Details: $($_.Exception.Message)"
        }
    }

    if (-not (Test-CommandAvailable -Name 'npm')) {
        throw 'NPM is not installed and GitHub installation failed.'
    }

    npm install -g tree-sitter-cli
}

function Install-LspRequirements {
    [CmdletBinding()]
    param()

    $npmDependencies = @(
        'alex',
        'neovim',
        'gh-actions-language-server',
        'azure-pipelines-language-server',
        'bash-language-server',
        'css-variables-language-server',
        '@microsoft/compose-language-service',
        'dockerfile-language-server-nodejs',
        'graphql-language-service-cli',
        'pyright',
        '@stoplight/spectral-cli',
        'yaml-language-server',
        'markdownlint',
        'markdownlint-cli2',
        'prettier',
        'stylelint',
        'write-good',
        'sql-formatter'
    )

    $pythonDependencies = @(
        'pyyaml',
        'nginx-language-server',
        'pynvim',
        'ruff',
        'ruff-lsp',
        'salt-lsp',
        'sqruff',
        'cmake-language-server',
        'mdformat',
        'ansible-lint',
        'yamlfix',
        'sqlfmt',
        'sqlformat'
    )

    $cargoDependencies = @('stylua')
    $goDependencies = @(
        'mvdan.cc/sh/v3/cmd/shfmt@latest',
        'github.com/rhysd/actionlint/cmd/actionlint@latest',
        'github.com/incu6us/goimports-reviser/v3@latest',
        'github.com/google/yamlfmt/cmd/yamlfmt@latest',
        'github.com/golangci/golangci-lint/cmd/golangci-lint@latest'
    )

    if (-not (Test-CommandAvailable -Name 'npm')) {
        throw 'NPM is not installed. Please install Node.js and NPM first.'
    }

    Install-MissingNpmGlobalPackages -Packages $npmDependencies

    $pythonCmd = if (Test-CommandAvailable -Name 'python') { 'python' } elseif (Test-CommandAvailable -Name 'python3') { 'python3' } else { $null }
    if (-not $pythonCmd) {
        throw 'Python is not installed.'
    }

    $pythonManager = if (Test-CommandAvailable -Name 'uv') { 'uv' } else { 'pip' }

    foreach ($pkg in $pythonDependencies) {
        & $pythonCmd -m pip show $pkg *> $null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Skipping Python package (already installed): $pkg"
            continue
        }

        Write-Host "Installing Python package: $pkg"
        try {
            if ($pythonManager -eq 'uv') {
                uv pip install --system $pkg
            }
            else {
                & $pythonCmd -m pip install $pkg
            }
        }
        catch {
            Write-Warning "Error installing Python dependency '$pkg': $($_.Exception.Message)"
        }
    }

    if (Test-CommandAvailable -Name 'go') {
        foreach ($pkg in $goDependencies) {
            go install $pkg
        }
    }
    else {
        Write-Warning 'Go is not installed. Skipping Go dependencies.'
    }

    if (Test-CommandAvailable -Name 'cargo') {
        foreach ($pkg in $cargoDependencies) {
            try {
                cargo install $pkg
            }
            catch {
                Write-Warning "Error installing Cargo dependency '$pkg': $($_.Exception.Message)"
            }
        }
    }
    else {
        Write-Warning 'Cargo is not installed. Skipping Cargo dependencies.'
    }

    Install-TreeSitterCli
}

function Install-Neovide {
    [CmdletBinding()]
    param()

    $installDir = Join-Path $env:LOCALAPPDATA 'Programs\Neovide'
    $startMenuDir = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
    $shortcutPath = Join-Path $startMenuDir 'Neovide.lnk'

    $release = Invoke-RestMethod -Uri 'https://api.github.com/repos/neovide/neovide/releases/latest' -Headers @{ 'User-Agent' = 'PowerShell' }
    $msiAsset = $release.assets | Where-Object { $_.name -like '*.msi' } | Select-Object -First 1
    $exeZipAsset = $release.assets | Where-Object { $_.name -like '*.exe.zip' } | Select-Object -First 1

    if (-not $msiAsset -or -not $exeZipAsset) {
        throw 'Could not locate expected Neovide release assets (MSI and portable EXE zip).'
    }

    $tempMsiPath = Join-Path $env:TEMP $msiAsset.name
    $tempZipPath = Join-Path $env:TEMP $exeZipAsset.name

    Invoke-WebRequest -Uri $msiAsset.browser_download_url -OutFile $tempMsiPath
    $msiProcess = Start-Process -FilePath 'msiexec.exe' -ArgumentList "/i `"$tempMsiPath`" /quiet /norestart" -Wait -PassThru -ErrorAction SilentlyContinue

    if ($msiProcess -and $msiProcess.ExitCode -eq 0) {
        Write-Host 'MSI installation succeeded.'
        return
    }

    Write-Warning "MSI installation failed (exit code: $($msiProcess.ExitCode)). Falling back to portable EXE zip."

    Invoke-WebRequest -Uri $exeZipAsset.browser_download_url -OutFile $tempZipPath
    if (-not (Test-Path -LiteralPath $installDir)) {
        New-Item -ItemType Directory -Path $installDir -Force | Out-Null
    }

    Expand-Archive -Path $tempZipPath -DestinationPath $installDir -Force

    $shell = New-Object -ComObject WScript.Shell
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = Join-Path $installDir 'Neovide.exe'
    $shortcut.WorkingDirectory = $installDir
    $shortcut.WindowStyle = 1
    $shortcut.IconLocation = Join-Path $installDir 'Neovide.exe'
    $shortcut.Save()
}
