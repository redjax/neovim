<#
.SYNOPSIS
    Synchronize Neovim's Lazy plugin manager plugins.

.DESCRIPTION
    Discovers all profiles in config/ that have a lazy-lock.json (i.e. use lazy.nvim)
    and updates their plugin lockfiles. You can override with -ProfileName.

    You can run this to update the lazy lockfiles for all your profiles, or the first time after installing the Neovim configs in this repo to initialize your plugins.

.PARAMETER ProfileName
    Profiles to update. By default, discovers all lazy.nvim profiles from config/.

.EXAMPLE
    .\lazy-sync.ps1
    .\lazy-sync.ps1 -ProfileName nvim-work
    .\lazy-sync.ps1 -ProfileName nvim, nvim-noplugins
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, HelpMessage = "Name of neovim configuration to install from the config/ directory. Can be provided multiple times.")]
    [string[]]$ProfileName = @()
)

$scriptPath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path -Parent $scriptPath
$libDir = Join-Path $scriptDir 'lib'

. (Join-Path $libDir 'Common.ps1')
. (Join-Path $libDir 'NvimOps.ps1')

$repoRoot = Get-RepoRootFromScript -ScriptPath $scriptPath
Invoke-LazySync -RepoRoot $repoRoot -ProfileName $ProfileName
