$cwd = Get-Location
$utils = @{
    "$cwd\wt\settings.json" = "$Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    "$cwd\pwsh\user_profile.ps1" = "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "$cwd\starship\starship.toml" = "$HOME\.config\starship\starship.toml"
    "$cwd\git\.gitconfig" = "$HOME\.gitconfig"
    "$cwd\cz\.czrc" = "$HOME\.czrc"
    "$cwd\glazewm\config.yaml" = "$HOME\.glaze-wm\config.yaml"
    "$cwd\wsl\.wslconfig" = "$HOME\.wslconfig"
    "$cwd\winfetch\config.ps1" = "$HOME\.config\winfetch\config.ps1"
    "$cwd\fastfetch\config.conf" = "$HOME\.config\fastfetch\config.conf"
    "$cwd\bottom\bottom.toml" = "$Env:APPDATA\bottom\bottom.toml"
    "$cwd\bat\config" = "$Env:APPDATA\bat\config"
    "$cwd\yt-dlp\config" = "$Env:APPDATA\yt-dlp\config"
    "$cwd\lf" = "$Env:LOCALAPPDATA\lf"
    "$cwd\nvchad" = "$Env:LOCALAPPDATA\nvim\lua\custom"
}

function Make-Shim {
    param(
        [Parameter(Mandatory=$True)][String]$ShimLink,
        [Parameter(Mandatory=$True)][String]$ShimTarget,
        [Parameter(Mandatory=$True)][ValidateSet("Leaf", "Container")][String]$ShimType
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
        [Parameter(Mandatory=$True)][String]$Source,
        [Parameter(Mandatory=$True)][String]$Destination
    )
    begin {
        $BackupPath = Join-Path -Path $cwd -ChildPath ".backup"
    }
    process {
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
}

function Install-Dotfiles {
    begin { Invoke-Command -ScriptBlock { gsudo cache on } }
    process {
        $utils.GetEnumerator() | ForEach-Object {
            Sync-Dotfiles -Source $_.Key -Destination $_.Value
        }
    }
    end { Invoke-Command -ScriptBlock { gsudo cache off } }
}

Install-Dotfiles
