# vim:fileencoding=utf-8:foldmethod=marker

# PSReadline {{{
Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -BellStyle None
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::White
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Gray
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Gray
    "Number" = [ConsoleColor]::Gray
    "Type" = [ConsoleColor]::Gray
    "Comment" = [ConsoleColor]::Gray
    "InlinePrediction" = [ConsoleColor]::Gray
    "Keyword" = [ConsoleColor]::White
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -HistoryNoDuplicates

# $OnViModeChange = [ScriptBlock]{
#     if ($args[0] -eq 'Command') { Write-Host -NoNewLine "`e[4 q" }
#     else { Write-Host -NoNewLine "`e[0 q" }
# }
# Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
    [Microsoft.Powershell.PSConsoleReadline]::RevertLine()
    [Microsoft.Powershell.PSConsoleReadline]::Insert("lfcd.ps1")
    [Microsoft.Powershell.PSConsoleReadline]::AcceptLine()
}

if ($Env:TERM_PROGRAM -eq "vscode") { Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord }
# }}}

# Environment Variables {{{
$Env:TERM = "xterm-256color"
$Env:EDITOR = "nvim.exe"
$Env:GIT_SSH = "C:\WINDOWS\System32\OpenSSH\ssh.exe"

$Env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
$Env:STARSHIP_CACHE = "$HOME\.config\starship\Temp"

# $Env:KOMOREBI_CONFIG_HOME = "$Env:USERPROFILE\.config\komorebi"
# $Env:WHKD_CONFIG_HOME = "$Env:USERPROFILE\.config\whkd"

$Env:FZF_DEFAULT_OPTS = @"
--height=40% --layout=reverse --info=inline --no-scrollbar --no-separator
"@
$Env:_ZO_FZF_OPTS = $Env:FZF_DEFAULT_OPTS

# $Env:RUST_BACKTRACE = 1
# $Env:RUSTFLAGS = "-C link-arg=-lmsvcrt"
$Env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"
$Env:RCLONE_CONFIG = "$Env:USERPROFILE\.config\rclone\rclone.conf"

$Env:PATH += ";$HOME\scoop\apps\git\current\usr\bin"
$Env:PATH += ";$HOME\.local\bin"
# }}}

# Functions {{{
function so { . $PROFILE.CurrentUserAllHosts }
function av { . "$PWD\*venv\Scripts\Activate.ps1" }
function which ($command) { Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }

if (Get-Command -Name "exa" -ErrorAction SilentlyContinue) {
    $ls_exe = "exa.exe"
    $ls_params = @('--color=always', '--group-directories-first', '--ignore-glob "NTUSER.DAT*|ntuser.dat*"')
    $ll_params = @('-la', '--icons')
}
else {
    $ls_exe = "ls.exe"
    $ls_params = @('--color=always', '--group-directories-first', '--ignore={"NTUSER.DAT*", "ntuser.dat*"}')
    $ll_params = @('-la')
}
function ls { Invoke-Expression -Command "$ls_exe $ls_params $Args" }
function ll { Invoke-Expression -Command "$ls_exe $ls_params $ll_params $Args" }

function vim { Invoke-Expression -Command "nvim.exe -u '$Env:USERPROFILE/dotfiles/init.vim' $Args" }
function pyv { Invoke-Expression -Command "python.exe '$Env:USERPROFILE/.local/bin/virtualenv.pyz' $Args" }

function wm {
    if (!(Get-Process -Name GlazeWM -ErrorAction SilentlyContinue)) {
        pwsh.exe -Command { Start-Process -FilePath "~\.local\bin\GlazeWM.exe" -WindowStyle Hidden }
    }
}

function Activate-Venv {
    begin {
        $ErrorActionPreference = "SilentlyContinue"
        $VENV_HOME = "C:\Softwares\Python\venvs"
    }
    process {
        $VENV_NAME = Get-ChildItem $VENV_HOME -Directory -Name | fzf
        $VENV_SCRIPT = "$VENV_HOME\$VENV_NAME\Scripts\Activate.ps1"
        if ( !($null -eq $VENV_NAME) ) { Invoke-Expression $VENV_SCRIPT }
    }
}

function Nvim-Fzf {
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $SelectedFile = Get-ChildItem -Path $(Get-Location) -Recurse -Force -File -Name | fzf
        if (!($null -eq $SelectedFile)) {
            Invoke-Command -ScriptBlock { nvim.exe $SelectedFile }
        }
    }
}

function Ripgrep-Fzf {
    begin {
        $ErrorActionPreference = "SilentlyContinue"
    }
    process {
        $AllContents = rg '--column' '--color=always' '--line-number' '--no-heading' '--smart-case' ''
        $SelectedItem = $AllContents | fzf '--ansi' `
            '--color' 'hl:-1:underline,hl+:-1:underline:reverse' `
            '--delimiter' ':' `
            '--preview' 'bat --color=always {1} --highlight-line {2}' `
            '--preview-window' 'up,60%,border-bottom,+{2}+3/3,~3'
        $Components = $SelectedItem -Split ":"
        
        if (!($Components.Length -eq 0)) {
            $FileName = $Components[0]
            $LineNumber = $Components[1]
            Invoke-Command -ScriptBlock { nvim.exe -c "e $FileName|$LineNumber" }
        }
    }
}


function Start-SSH-Agent {
    $Status = $(Get-Service -Name "ssh-agent").Status
    if ($Status -eq "Stopped") {
        Start-Service -Name "ssh-agent"

        $SelectedKey = Invoke-Command -ScriptBlock { Get-ChildItem -Path ~/.ssh/ -Exclude *.pub,config,known_host* -Name | fzf.exe }
        Invoke-Command -ScriptBlock { ssh-add $HOME/.ssh/$SelectedKey  }
        Write-Host "SSH Agent started"
    }
    else {
        Write-Host "SSH Agent already running"
    }
}

function br {
    $args = $args -join ' '
    $cmd_file = New-TemporaryFile
    $process = Start-Process -FilePath 'broot.exe' `
                             -ArgumentList "--outcmd $($cmd_file.FullName) $args" `
                             -NoNewWindow -PassThru -WorkingDirectory $PWD

    Wait-Process -InputObject $process
    if ($process.ExitCode -eq 0) {
        $cmd = Get-Content $cmd_file
        Remove-Item $cmd_file
        if ($cmd -ne $null) { Invoke-Expression -Command $cmd }
    } else {
        Remove-Item $cmd_file
        Write-Host "`n"
        Write-Error "broot.exe exited with error code $($process.ExitCode)"
    }
}

function Invoke-Starship-PreCommand {
    $loc = $executionContext.SessionState.Path.CurrentLocation;
    $prompt = "$([char]27)]9;12$([char]7)"
    if ($loc.Provider.Name -eq "FileSystem")
    {
        $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }
    $host.ui.Write($prompt)
}
# }}}

# Aliases {{{
Set-Alias "lzg" "lazygit"
Set-Alias "lzd" "lazydocker"
Set-Alias "dl" "yt-dlp"
Set-Alias "da" "deactivate"
Set-Alias "co" "codium"
Set-Alias "ff" "fastfetch"
Set-Alias "af" Activate-Venv
Set-Alias "nf" Nvim-Fzf
Set-Alias "rf" Ripgrep-Fzf
Set-Alias "mf" Mpv-Fzf
Set-Alias "sa" Start-SSH-Agent
# }}}

# {{{
$utils = @("cat", "cp", "diff", "echo", "kill", "ls", "mv", "ps", "pwd", "rm", "sleep", "tee")
$utils.ForEach({ Remove-Alias -Name $_ -Force -ErrorAction Ignore })
Remove-Item -Path Function:\mkdir -ErrorAction Ignore
# }}}

# Init {{{
Invoke-Expression ( & { (starship init powershell | Out-String) } )
Invoke-Expression ( & { (zoxide init powershell | Out-String) } )
# }}}
