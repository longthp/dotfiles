$utils = @("cat", "cp", "diff", "echo", "kill", "ls", "mv", "ps", "pwd", "rm", "sleep", "tee")
$utils.ForEach({ Remove-Alias -Name $_ -Force -ErrorAction Ignore })
Remove-Item -Path Function:\mkdir -ErrorAction Ignore

$OnViModeChange = [ScriptBlock]{
    if ($args[0] -eq 'Command') { Write-Host -NoNewLine "`e[4 q" }
    else { Write-Host -NoNewLine "`e[0 q" }
}

Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange
Set-PSReadLineOption -BellStyle None
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::White
    "Parameter" = [ConsoleColor]::DarkGray
    "Operator" = [ConsoleColor]::DarkGray
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Gray
    "Number" = [ConsoleColor]::Gray
    "Type" = [ConsoleColor]::Gray
    "Comment" = [ConsoleColor]::DarkGray
    "InlinePrediction" = [ConsoleColor]::DarkGray
    "Keyword" = [ConsoleColor]::White
}

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -HistoryNoDuplicates

Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
    [Microsoft.Powershell.PSConsoleReadline]::RevertLine()
    [Microsoft.Powershell.PSConsoleReadline]::Insert("lfcd.ps1")
    [Microsoft.Powershell.PSConsoleReadline]::AcceptLine()
}

if ($Env:TERM_PROGRAM -eq "vscode") { Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord }

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

$Env:RUST_BACKTRACE = 1
$Env:RUSTFLAGS = "-C link-arg=-lmsvcrt"
$Env:YAZI_CONFIG_HOME = "$HOME\.config\yazi"

$Env:PATH += ";C:\Softwares\node"
$Env:PATH += ";$HOME\scoop\apps\git\current\usr\bin"
$Env:PATH += ";$HOME\.local\bin"

function so { . $PROFILE.CurrentUserAllHosts }
function av { . ".\venv\Scripts\Activate.ps1" }
function which ($command) { Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }


$ls_params = @('--color=always', '--group-directories-first', '--ignore={"NTUSER.DAT*", "ntuser.dat*"}')
function ls ($item) { Invoke-Command -ScriptBlock { ls.exe $ls_params $item } }
function ll ($item) { Invoke-Command -ScriptBlock { ls.exe '--show-control-chars' '-CFGNlhap' $ls_params $item } }

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
    begin {
        $Status = $(Get-Service -Name "ssh-agent").Status
    }
    process {
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
}

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

function Invoke-Starship-PreCommand {
    $loc = $executionContext.SessionState.Path.CurrentLocation;
    $prompt = "$([char]27)]9;12$([char]7)"
    if ($loc.Provider.Name -eq "FileSystem")
    {
        $prompt += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }
    $host.ui.Write($prompt)
}

Invoke-Expression ( & { (starship init powershell | Out-String) } )
Invoke-Expression ( & { (zoxide init powershell | Out-String) } )
