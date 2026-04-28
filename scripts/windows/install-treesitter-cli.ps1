[CmdletBinding()]
Param(
    [switch]$Force
)

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Error "NPM is not installed. Please install Node.js/NPM first."
    exit 1
}

if ((-not $Force) -and (Get-Command tree-sitter -ErrorAction SilentlyContinue)) {
    $Version = tree-sitter --version
    Write-Host "tree-sitter already installed: $Version"
    exit 0
}

Write-Host "Installing tree-sitter-cli with npm..."
try {
    npm install -g tree-sitter-cli
}
catch {
    Write-Error "Failed to install tree-sitter-cli. Details: $($_.Exception.Message)"
    exit 1
}

if (Get-Command tree-sitter -ErrorAction SilentlyContinue) {
    $Version = tree-sitter --version
    Write-Host "tree-sitter installed: $Version"
    exit 0
}

Write-Warning "tree-sitter-cli installed but 'tree-sitter' is not in PATH yet."
Write-Host "Open a new terminal and verify with: tree-sitter --version"
exit 1
