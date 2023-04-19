# ===== WINFETCH CONFIGURATION =====
# $image = "~/catppuccin_circle.png"
# $noimage = $true

# Display image using ASCII characters
$ascii = $true

# Set the version of Windows to derive the logo from.
$logo = "Windows 11"

# Specify width for image/logo
# $imgwidth = 36

# Specify minimum alpha value for image pixels to be visible
# $alphathreshold = 100


$ShowDisks = @("*")
$ShowPkgs = @("scoop")

$memorystyle = 'bartext'
$diskstyle = 'bartext'
$batterystyle = 'bartext'

@(
    "title"
    "dashes"
    "os"
    "computer"
    "kernel"
    "motherboard"
    "uptime"
    "pkgs"
    "terminal"
    "cpu"
    "gpu"
    "memory"
    "disk"
    "battery"
    # "blank"
    # "colorbar"
)
