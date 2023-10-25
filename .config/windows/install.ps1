function Test-IsAdministrator {
    return (
        [Security.Principal.WindowsPrincipal]`
        [Security.Principal.WindowsIdentity]::GetCurrent()`
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -and $env:USERNAME -ne 'WDAGUtilityAccount'
}

function New-Symbolic-Link {
    param (
        [Parameter(Mandatory=$True, Position=0)][String]$Link,
        [Parameter(Mandatory=$True, Position=1)][String]$Target
    )
    process {
        Invoke-Command -ScriptBlock { cmd.exe /c mklink $Link $Target *> $null}
        Write-Host "[shim] $Target => $Link"
    }
}

function Test-CommandAvailable {
    param (
        [Parameter(Mandatory=$True, Position=0)][String]$Command
    )
    return [Boolean](Get-Command $Command -ErrorAction SilentlyContinue)
}

function Install-Dotfiles {
    param (
        [System.Array]$Applications
    )

    $Applications | ForEach-Object -Process {
        if ($_.source) {
            $S_Parent = Resolve-Path -Path $_.source
            $D_Parent = New-Item -ItemType Directory -Path $_.dest -Force | Resolve-Path

            if ($_.dest -ne "~") {
                # remove old symbolic links
                Get-ChildItem -Recurse $D_Parent -File | ForEach-Object -Process {
                    if (!(Test-Path $_.ResolvedTarget)) {
                        Write-Host "[clean] removing [$_]"
                        Remove-Item -Path $_
                    }
                }
            }

            # add actual symbolic links
            Get-ChildItem -Recurse $_.source -File | ForEach-Object -Process {
                $S_Item_FullName = $_.FullName.Split($S_Parent).Get(1)
                $D_Symlink = Join-Path -Path $D_Parent -ChildPath $S_Item_FullName
                $D_Symlink = $D_Symlink.Split("::").Get(1)

                try {
                    New-Symbolic-Link -Link $D_Symlink -Target $_ -ErrorAction Stop
                }
                catch {
                    $ErrorClass = $_.Exception.GetType().Name
                    if ($ErrorClass -eq "NativeCommandExitException") {
                        Write-Host "[warn] skip existed [$D_Symlink]"
                    }
                }
            }
        }
    }
}


# start installation
$apps = Import-Csv -Path "$Env:USERPROFILE\dotfiles\.config\windows\apps.csv"

Install-Dotfiles -Applications $apps
