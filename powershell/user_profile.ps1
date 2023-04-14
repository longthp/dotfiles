Import-Module -Name PSReadline
Import-Module -Name CompletionPredictor
Import-Module -Name DockerCompletion
Import-Module -Name PwshComplete
Import-Module -Name PSGitCompletions
# Import-Module -Name PSFzf

$utils = "cat", "cp", "diff", "echo", "kill", "ls", "mv", "ps", "pwd", "mkdir", "rm", "sleep", "tee"
foreach ($u in $utils) { Remove-Alias -Name $u -Force -ErrorAction Ignore }

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
# Set-PSReadLineKeyHandler -Chord Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadLineKeyHandler -Chord Ctrl+d -Function DeleteChar
Set-PSReadlineKeyHandler -Chord Ctrl+k -Function TabCompletePrevious
Set-PSReadlineKeyHandler -Chord Ctrl+j -Function TabCompleteNext

if ($env:TERM_PROGRAM -eq "vscode") { Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardKillWord }

# Environment variables
$env:TERM = "xterm-256color"
$env:EDITOR = "nvim.exe"

$env:STARSHIP_CONFIG = "$HOME\.config\starship\starship.toml"
$env:STARSHIP_CACHE = "$HOME\.config\starship\Temp"

$env:FZF_DEFAULT_OPTS=@"
--height=40% --layout=reverse --info=inline --no-scrollbar --no-separator
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"@
$env:_ZO_FZF_OPTS = $FZF_DEFAULT_OPTS

$env:RUST_BACKTRACE = 1

#$env:PYENV_ROOT = "$HOME\.pyenv\pyenv-win"
#$env:PYENV_HOME = "$HOME\.pyenv\pyenv-win"
#$env:PYENV = "$HOME\.pyenv\pyenv-win"

$env:PATH += ";C:\Softwares\node"
$env:PATH += ";C:\Users\long\scoop\apps\git\current\usr\bin"
$env:PATH += ";C:\Softwares\Python\Python310\"
$env:PATH += ";C:\Softwares\Python\Python310\Scripts"


function which ($command) { Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue }

function ls { ls.exe '--color=always' '--group-directories-first' '--ignore={"NTUSER.DAT*","ntuser.dat*"}' $args[0] }
function ll { ls.exe '--color=always' '--group-directories-first' '--show-control-chars' '-CFGNlhap' '--ignore={"NTUSER.DAT*","ntuser.dat*"}' $args[0] }

function wm { Start-Process glazewm -ArgumentList "--config $HOME/.glaze-wm/config.yaml" -WindowStyle Hidden }
function bb { Start-Process btm -ArgumentList "--basic"}

$venvs = "base", "sfds", "img", "wbscrp", "wbatm", "wbapi"
foreach ($v in $venvs) { Set-Alias $v "C:\Softwares\Python\venvs\$v\Scripts\Activate.ps1" }
Set-Alias "co" "codium"
Set-Alias "lzg" "lazygit"
Set-Alias "lzd" "lazydocker"
Set-Alias "dl" "yt-dlp"

Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})
Invoke-Expression (& starship.exe init powershell)
