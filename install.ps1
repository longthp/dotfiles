$Mappings = [ordered]@{
    "git" = "$HOME"
    "cz" = "$HOME"
    "wsl" = "$HOME"
    "glazewm" = "$HOME\.glaze-wm"
    "wezterm" = "$HOME\.config\wezterm"
    "starship" = "$HOME\.config\starship"
    "winfetch" = "$HOME\.config\winfetch"
    "fastfetch" = "$HOME\.config\fastfetch"
    "pwsh" = "$HOME\Documents\PowerShell"
    "wt" = "$Env:LOCALAPPDATA\Microsoft\Windows Terminal"
    "bottom" = "$Env:APPDATA\bottom"
    "bat" = "$Env:APPDATA\bat"
    "yt-dlp" = "$Env:APPDATA\yt-dlp"
    "lf" = "$Env:LOCALAPPDATA\lf"
    "nvim" = "$Env:LOCALAPPDATA\nvim"
}

function Install-Dotfiles {
    begin { Invoke-Command -ScriptBlock { gsudo cache on } }
    process {
        $Mappings.GetEnumerator().ForEach({
            $S_Parent = $_.Key # Source parent directory name
            $D_Parent = $_.Value # Destiation parent directory name
            if (!(Test-Path $D_Parent)) {
                # Check if destination directory exists:
                Write-Host "[warn] Creating missing folder:" $D_Parent
                New-Item -ItemType Directory $D_Parent | Out-Null
            }

            $S_Items = Get-ChildItem -Recurse $_.Key -File # Recursively list all files
            $S_Items.ForEach({
                # Get the nested source parent directory structure
                $D_Symlink = Join-Path -Path $D_Parent -ChildPath $(Split-Path $_.FullName).Split($S_Parent).Get(1) | Join-Path -ChildPath $_.Name
                
                Write-Host "[info] $_ => $D_Symlink"

                $ItemType = "SymbolicLink"
                Invoke-Gsudo { New-Item -ItemType $using:ItemType -Path $using:D_Symlink -Target $using:_ -Force | Out-Null }
            })
        })
    }
    end { Invoke-Command -ScriptBlock { gsudo cache off } }
}

Install-Dotfiles
