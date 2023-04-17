# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# irm get.scoop.sh | iex

function Test-IsAdmin {
  return (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if ((Test-IsAdmin) -eq $false) {
    Write-Warning "This script requires local admin privileges. Elevating..."
    gsudo "& '$($MyInvocation.MyCommand.Source)'" $args
    if ($LastExitCode -eq 999 ) { Write-error 'Failed to elevate.' }
    return
}

function Make-Single-Shim {
    param(
        [Parameter(Mandatory=$True)][string[]]$Link,
        [Parameter(Mandatory=$True)][string[]]$Target
    )
    gsudo New-Item -ItemType SymbolicLink -Path $Link -Target $Target -Force | Out-Null
    Write-Host "Made Shim: $Target -> $Link"
}

$cwd = $(Get-Location)
$utils = @{
    "$cwd\wt\settings.json" = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "$cwd\pwsh\user_profile.ps1" = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "$cwd\starship\starship.toml" = "$HOME\.config\starship\starship.toml"
    "$cwd\git\.gitconfig" = "$HOME\.gitconfig"
    "$cwd\cz\.czrc" = "$HOME\.czrc"
    "$cwd\glazewm\config.yaml" = "$HOME\.glaze-wm\config.yaml"
    "$cwd\wsl\.wslconfig" = "$HOME\.wslconfig"
    "$cwd\lf\lfrc" = "$HOME\AppData\Local\lf\lfrc"
    "$cwd\lf\colors" = "$HOME\AppData\Local\lf\colors"
    "$cwd\lf\icons" = "$HOME\AppData\Local\lf\icons"
    "$cwd\bottom\bottom.toml" = "$HOME\AppData\Roaming\bottom\bottom.toml"
    "$cwd\bat\config" = "$HOME\AppData\Roaming\bat\config"
    "$cwd\yt-dlp\config" = "$HOME\AppData\Roaming\yt-dlp\config"
    "$cwd\winfetch\config.ps1" = "$HOME\.config\winfetch\config.ps1"
}

foreach ($item in $utils.Keys) { Make-Single-Shim -Link $utils[$item] -Target $item }
