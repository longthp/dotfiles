$cwd = Get-Location
$utils = @{
    "$cwd\wt\settings.json" = "$HOME\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "$cwd\pwsh\user_profile.ps1" = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "$cwd\starship\starship.toml" = "$HOME\.config\starship\starship.toml"
    "$cwd\git\.gitconfig" = "$HOME\.gitconfig"
    "$cwd\cz\.czrc" = "$HOME\.czrc"
    "$cwd\glazewm\config.yaml" = "$HOME\.glaze-wm\config.yaml"
    "$cwd\wsl\.wslconfig" = "$HOME\.wslconfig"
    "$cwd\lf" = "$HOME\AppData\Local\lf"
    "$cwd\bottom\bottom.toml" = "$HOME\AppData\Roaming\bottom\bottom.toml"
    "$cwd\bat\config" = "$HOME\AppData\Roaming\bat\config"
    "$cwd\yt-dlp\config" = "$HOME\AppData\Roaming\yt-dlp\config"
    "$cwd\winfetch\config.ps1" = "$HOME\.config\winfetch\config.ps1"
    "$cwd\fastfetch\config.conf" = "$HOME\.config\fastfetch\config.conf"
}

function Make-Shim {
    param(
        [Parameter(Mandatory=$True)][string[]]$ShimLink,
        [Parameter(Mandatory=$True)][string[]]$ShimTarget,
        [Parameter(Mandatory=$True)][ValidateSet("Leaf", "Container")][string[]]$ShimType
    )
    if ("Leaf" -eq $ShimType) {
        gsudo New-Item -ItemType SymbolicLink -Path $ShimLink -Target $ShimTarget -Force | Out-Null
        Write-Host "[shim] Created Leaf: $ShimTarget -> $ShimLink"
    }
    else {
        $Leafs = Get-ChildItem -LiteralPath $ShimTarget -Recurse
        $Leafs.GetEnumerator() | ForEach-Object {
            $LeafLink = Join-Path -Path $ShimLink -ChildPath $(Split-Path -Path $_ -Leaf)
            gsudo New-Item -ItemType SymbolicLink -Path $LeafLink -Target $_ -Force | Out-Null
            Write-Host "[shim] Created CLeaf: $_ -> $LeafLink"
        }
        Write-Host "[shim] Created Container: $ShimTarget -> $ShimLink"
    }
}

function Sync-Dotfiles {
    param (
        [Parameter(Mandatory=$True)][string[]]$Source,
        [Parameter(Mandatory=$True)][string[]]$Destination
    )
    $BackupPath = Join-Path -Path $(Get-Location) -ChildPath ".backup"
    if (Test-Path -Path $Source -PathType Leaf) {
        if (Test-Path -Path $Destination -PathType Leaf) {
            Copy-Item -Path $Destination -Destination $BackupPath -Force
            # Write-Host "[back] Copied Leaf $Destination -> $BackupPath"
        }
        Make-Shim -ShimLink $Destination -ShimTarget $Source -ShimType "Leaf"
    }
    elseif (Test-Path -Path $Source -PathType Container) {
        if (Test-Path -Path $Destination -PathType Container) {
            Copy-Item -Path $Destination -Destination $BackupPath -Recurse -Force
            # Write-Host "[back] Copied Container $Destination -> $BackupPath"
        }
        Make-Shim -ShimLink $Destination -ShimTarget $Source -ShimType "Container"
    }
}

function Install-Dotfiles {
    gsudo cache on
    $utils.GetEnumerator() | ForEach-Object {
        Sync-Dotfiles -Source $_.Key -Destination $_.Value
    }
    gsudo cache off
}

Install-Dotfiles
