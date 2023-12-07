UserHome := EnvGet("UserProfile")

!b::Run UserHome . "/scoop/apps/brave/current/brave.exe"
!f::Run UserHome . "/scoop/apps/firefox/current/firefox.exe"
!n::Run UserHome . "/scoop/apps/sublime-text/current/sublime_text.exe"

!Enter::Run UserHome . "/scoop/apps/wezterm/current/wezterm.exe",, "Hide"
!+w::Run "winword.exe"
!+e::Run "excel.exe"

!v::RunWait "fancywm.exe --action CreateVerticalPanel",, "Hide"
!s::RunWait "fancywm.exe --action CreateHorizontalPanel",, "Hide"
!+v::RunWait "fancywm.exe --action PullWindowUp",, "Hide"

!1::RunWait "virtualdesktop11-23h2.exe -Switch:0",, "Hide"
!2::RunWait "virtualdesktop11-23h2.exe -Switch:1",, "Hide"
!3::RunWait "virtualdesktop11-23h2.exe -Switch:2",, "Hide"
!4::RunWait "virtualdesktop11-23h2.exe -Switch:3",, "Hide"
!5::RunWait "virtualdesktop11-23h2.exe -Switch:4",, "Hide"
!6::RunWait "virtualdesktop11-23h2.exe -Switch:5",, "Hide"
!7::RunWait "virtualdesktop11-23h2.exe -Switch:6",, "Hide"
!8::RunWait "virtualdesktop11-23h2.exe -Switch:7",, "Hide"
!9::RunWait "virtualdesktop11-23h2.exe -Switch:8",, "Hide"

!+1::RunWait "virtualdesktop11-23h2.exe -GetDesktop:0 -MoveActiveWindow -Switch",, "Hide"
!+2::RunWait "virtualdesktop11-23h2.exe -GetDesktop:1 -MoveActiveWindow -Switch",, "Hide"
!+3::RunWait "virtualdesktop11-23h2.exe -GetDesktop:2 -MoveActiveWindow -Switch",, "Hide"
!+4::RunWait "virtualdesktop11-23h2.exe -GetDesktop:3 -MoveActiveWindow -Switch",, "Hide"
!+5::RunWait "virtualdesktop11-23h2.exe -GetDesktop:4 -MoveActiveWindow -Switch",, "Hide"
!+6::RunWait "virtualdesktop11-23h2.exe -GetDesktop:5 -MoveActiveWindow -Switch",, "Hide"
!+7::RunWait "virtualdesktop11-23h2.exe -GetDesktop:6 -MoveActiveWindow -Switch",, "Hide"
!+8::RunWait "virtualdesktop11-23h2.exe -GetDesktop:7 -MoveActiveWindow -Switch",, "Hide"
!+9::RunWait "virtualdesktop11-23h2.exe -GetDesktop:8 -MoveActiveWindow -Switch",, "Hide"

!+q::WinClose "A"
