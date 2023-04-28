Import-Module -Name PSReadline
Import-Module -Name CompletionPredictor
Import-Module -Name DockerCompletion
Import-Module -Name PwshComplete
Import-Module -Name PSGitCompletions

# $Scripts = Join-Path -Path $(Split-Path $PROFILE -Parent) -ChildPath "Script"

function Source-File {
    param(
        [Parameter(Mandatory=$True)][string[]]$File
    )
    if ( -not (Test-Path -Path $File -PathType Leaf) ) {
        Write-Host "Skip non-existing script."
    }
    else {
        Write-Host "Loaded: $(Split-Path -Path $File -Leaf)"
        . $File
    }
}

# Source-File -File "$PSScriptRoot\user\env.ps1"
# Source-File -File "$PSScriptRoot\user\functions.ps1"
# Source-File -File "$PSScriptRoot\user\options.ps1"
# Source-File -File "$PSScriptRoot\user\alias.ps1"

$utils = @("cat", "cp", "diff", "echo", "kill", "ls", "mv", "ps", "pwd", "rm", "sleep", "tee")
ForEach-Object -InputObject $utils -Process {Remove-Alias -Name $_ -Force -ErrorAction Ignore}
Remove-Item -Path Function:\mkdir -ErrorAction Ignore

$OnViModeChange = [scriptblock]{
    if ($args[0] -eq 'Command') { Write-Host -NoNewLine "`e[4 q" }
    else { Write-Host -NoNewLine "`e[0 q" }
}

Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange
Set-PSReadLineOption -BellStyle None
Set-PSReadlineOption -Color @{
    "Command" = [ConsoleColor]::Green
    "Parameter" = [ConsoleColor]::Gray
    "Operator" = [ConsoleColor]::Magenta
    "Variable" = [ConsoleColor]::White
    "String" = [ConsoleColor]::Yellow
    "Number" = [ConsoleColor]::Blue
    "Type" = [ConsoleColor]::Cyan
    "Comment" = [ConsoleColor]::DarkCyan
    "InlinePrediction" = [ConsoleColor]::DarkGray
}

Set-PSReadLineOption -PredictionSource Plugin
Set-PSReadLineOption -PredictionViewStyle InlineView
Set-PSReadLineOption -HistoryNoDuplicates

# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
# Set-PSFzfOption -EnableAliasFuzzyHistory

Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadLineKeyHandler -Chord Ctrl+o -ScriptBlock {
    [Microsoft.Powershell.PSConsoleReadline]::RevertLine()
    [Microsoft.Powershell.PSConsoleReadline]::Insert("lfcd.ps1")
    [Microsoft.Powershell.PSConsoleReadline]::AcceptLine()
}

if ($env:TERM_PROGRAM -eq "vscode") { Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord }

$Env:TERM = "xterm-256color"
$Env:EDITOR = "nvim.exe"

$Env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
$Env:STARSHIP_CACHE = "$HOME\.config\starship\Temp"

$Env:FZF_DEFAULT_OPTS=@"
--height=40% --layout=reverse --info=inline --no-scrollbar --no-separator
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"@
$Env:_ZO_FZF_OPTS = $Env:FZF_DEFAULT_OPTS

$Env:RUST_BACKTRACE = 1

$Env:PYENV_ROOT = "$HOME\.pyenv\pyenv-win"
$Env:PYENV_HOME = "$HOME\.pyenv\pyenv-win"
$Env:PYENV = "$HOME\.pyenv\pyenv-win"

$Env:PATH += ";$HOME\scoop\apps\git\current\usr\bin"
$Env:PATH += ";$HOME\.pyenv\pyenv-win\bin"
$Env:PATH += ";$HOME\.pyenv\pyenv-win\shims"
$Env:PATH += ";C:\Softwares\node"
$Env:PATH += ";C:\Softwares\Python\Python310"
$Env:PATH += ";C:\Softwares\Python\Python310\Scripts"

function so { . $PROFILE }
function which ($command) { Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }

function ls { ls.exe '--color=always' '--group-directories-first' '--ignore={"NTUSER.DAT*","ntuser.dat*"}' $args[0] }
function ll { ls.exe '--color=always' '--group-directories-first' '--show-control-chars' '-CFGNlhap' '--ignore={"NTUSER.DAT*","ntuser.dat*"}' $args[0] }

function wm { Start-Process glazewm -ArgumentList "--config $HOME\.glaze-wm\config.yaml" -WindowStyle Hidden }


function Activate-Venv {
    $VENV_HOME = "C:\Softwares\Python\venvs"
    $VENV_NAME = Get-ChildItem $VENV_HOME -Directory -Name | fzf
    $VENV_SCRIPT = "$VENV_HOME\$VENV_NAME\Scripts\Activate.ps1"

    if ( (Test-Path -Path $VENV_SCRIPT -PathType Leaf) -And !($null -eq $VENV_NAME) ) { Invoke-Expression $VENV_SCRIPT }
}

function Nvim-Fzf {
    $SelectedFile = Get-ChildItem -Path $(Get-Location) -Recurse -Force -File -Name | fzf
    if ( -not ($null -eq $SelectedFile) ) { Invoke-Expression "nvim $SelectedFile" }
}

Set-Alias "lzg" "lazygit"
Set-Alias "lzd" "lazydocker"
Set-Alias "dl" "yt-dlp"
Set-Alias "da" "deactivate"
Set-Alias "co" "codium"
Set-Alias "av" Activate-Venv
Set-Alias "nf" Nvim-Fzf
Set-Alias "ff" "fastfetch"

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
Invoke-Expression (& starship.exe init powershell)
