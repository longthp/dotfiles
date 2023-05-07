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
    # "nvchad" = "$Env:LOCALAPPDATA\nvim\lua\custom"
}


function Install-Dotfiles {
    begin {
        Invoke-Command -ScriptBlock { gsudo cache on }
        Write-Host "[gsudo] Syncing dotfiles..."
    }
    process {
        $Mappings.GetEnumerator().ForEach({
            $S_Parents = $_.Key
            $D_Parents = $_.Value
            if (!(Test-Path $D_Parents)) {
                Write-Host "[warn] Creating missing folder:" $D_Parents
            }

            $S_Items = Get-ChildItem -Recurse $_.Key
            $S_Items.ForEach({
                $D_Symlink = Join-Path -Path $D_Parents -ChildPath $_.Name
                Write-Host "[info] $_ => $D_Symlink"
                gsudo {
                    New-Item -ItemType $args[0] -Path $args[1] -Target $args[2] -Force | Out-Null
                } -args "SymbolicLink", $D_Symlink, $_
            })
        })
    }
    end {
        Invoke-Command -ScriptBlock { gsudo cache off }
        Write-Host "[gsudo] Completed!"
    }
}

Install-Dotfiles
