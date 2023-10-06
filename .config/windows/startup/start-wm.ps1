$KOMOREBI_APPS = [ordered]@{
    "MicaForEveryone" = "~\scoop\apps\micaforeveryone\current\MicaForEveryone.exe"
    "FancyBorders" = "~\.local\bin\FancyBorders.exe"
    "PowerToys" = "~\scoop\apps\powertoys\current\PowerToys.exe"
    # "yasb" = "~\.local\bin\yasb.exe"
    # "whkd" = "~\scoop\apps\whkd\current\whkd.exe"
}


$GLAZEWM_APPS = [ordered]@{
    "MicaForEveryone" = "~\scoop\apps\micaforeveryone\current\MicaForEveryone.exe"
    "FancyBorders" = "~\.local\bin\FancyBorders.exe"
    "FLow.Launcher" = "~\scoop\apps\flow-launcher\current\Flow.Launcher.exe"
    "GlazeWM" = "~\.local\bin\GlazeWM.exe"
    # "QuickLook" = "~\scoop\apps\quicklook\current\QuickLook.exe"
}

function Test-Process {
    param (
        [Parameter(Mandatory=$True, Position=0)][String]$ProcessName
    )
    return [Boolean](Get-Process -Name $ProcessName -ErrorAction SilentlyContinue)
}

function Start-Exe {
    param (
        [Parameter(Mandatory=$True, Position=0)][String]$ExeName,
        [Parameter(Mandatory=$True, Position=1)][String]$ExePath
    )
    begin {
        $OLD_DIR = $(Get-Location)
        Set-Location -Path $(Get-Item $ExePath).DirectoryName
    }
    process {
        if (!(Test-Process $ExeName)) {
            Start-Process -FilePath $ExePath -WindowStyle Hidden
        }
    }
    end {
        Set-Location -Path $OLD_DIR
    }
}

function WM-Komorebi {
    begin {
        $YASB_HOME = "$Env:USERPROFILE\.local\bin\repos\yasb"
        $YASB_CONFIG_HOME = "$Env:USERPROFILE\.yasb"
    }
    process {
        if (!(Test-Process "komorebi")) {
            Invoke-Command -ScriptBlock { komorebic.exe start -c "$Env:USERPROFILE\komorebi.json" --whkd }
        }

        $KOMOREBI_APPS.GetEnumerator().ForEach({
            Start-Exe -ExeName $_.Key -ExePath $_.Value
        })

        Start-Sleep -Seconds 5
        Start-Process -FilePath "$YASB_CONFIG_HOME\venv\Scripts\python.exe" -ArgumentList "$YASB_HOME\src\main.py" -WindowStyle Hidden
    }
}

function WM-GlazeWM {
    $GLAZEWM_APPS.GetEnumerator().ForEach({
        Start-Exe -ExeName $_.Key -ExePath $_.Value
    })
}

WM-GlazeWM
