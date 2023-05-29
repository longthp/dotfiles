$Mappings = [ordered]@{
    "git" = "$HOME"
    "cz" = "$HOME"
    "wsl" = "$HOME"
    "glazewm" = "$HOME\.glaze-wm"
    # "wezterm" = "$HOME\.config\wezterm"
    "starship" = "$HOME\.config\starship"
    "winfetch" = "$HOME\.config\winfetch"
    "fastfetch" = "$HOME\.config\fastfetch"
    "pwsh" = "$HOME\Documents\PowerShell"
    "wt" = "$HOME\scoop\persist\windows-terminal\settings"
    # "wt" = "$Env:LOCALAPPDATA\Microsoft\Windows Terminal"
    "bottom" = "$Env:APPDATA\bottom"
    "bat" = "$Env:APPDATA\bat"
    "yt-dlp" = "$Env:APPDATA\yt-dlp"
    "lf" = "$Env:LOCALAPPDATA\lf"
    "nvim" = "$Env:LOCALAPPDATA\nvim"
}

function Test-IsAdmin {
    return (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if ( (Test-IsAdmin) -eq $False ) {
    Write-Warning "This script requires local admin privileges. Elevating..."
    gsudo "& '$( $MyInvocation.MyCommand.Source )'" $args
    if ( $LastExitCode -eq 999 ) {
        Write-Error 'Failed to elevate.'
    }
    return
}

function Install-Dotfiles {
    $Mappings.GetEnumerator().ForEach({
        $S_Parent = Resolve-Path -Path $_.Key
        $D_Parent = $_.Value
        if (!(Test-Path $D_Parent)) {
            Write-Host "[warn] Creating missing folder:" $D_Parent
            New-Item -ItemType Directory $D_Parent | Out-Null
        }

        $S_Items = Get-ChildItem -Recurse $_.Key -File
        $S_Items.ForEach({
            $S_Item_FullName = $_.FullName.Split($S_Parent).Get(1)
            $D_Symlink = Join-Path -Path $D_Parent -ChildPath $S_Item_FullName

            Write-Host "[info] $_ => $D_Symlink"
            New-Item -ItemType SymbolicLink -Path $D_Symlink -Target $_ -Force | Out-Null
        })
    })
}

Install-Dotfiles
