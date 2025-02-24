# Ensure PowerShell Core
if ($PSVersionTable.PSEdition -ne "Core") {
    Write-Output "Please run this script using PowerShell Core (pwsh)."
    exit 1
}

# Get script location (root of repo)
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$configFile = "$repoRoot/config.json"

# Load Configuration
if (-Not (Test-Path $configFile)) {
    Write-Output "Configuration file missing! Please create config.json."
    exit 1
}

$config = Get-Content $configFile | ConvertFrom-Json
$apiKey = $config.apiKey
$zipCode = $config.zipCode
$country = $config.country
$wallpaperPath = "$repoRoot/wallpapers"

# Validate API Key
if ($apiKey -eq "YOUR_OPENWEATHERMAP_API_KEY") {
    Write-Output "API key not set. Please update config.json."
    exit 1
}

# Lookup Latitude/Longitude from ZIP Code
$geoUrl = "https://api.openweathermap.org/geo/1.0/zip?zip=$zipCode,$country&appid=$apiKey"

try {
    $geoData = Invoke-RestMethod -Uri $geoUrl -Method Get
    $lat = $geoData.lat
    $lon = $geoData.lon
    if (-not $lat -or -not $lon) {
        Write-Output "Invalid ZIP Code. Check config.json."
        exit 1
    }
} catch {
    Write-Output "Failed to retrieve location data. Check API key and internet connection."
    exit 1
}

# Fetch Current Weather Data
$weatherUrl = "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=imperial"

try {
    $weatherData = Invoke-RestMethod -Uri $weatherUrl -Method Get
} catch {
    Write-Output "Failed to retrieve weather data."
    exit 1
}

# Extract Weather Data
$weatherCondition = $weatherData.current.weather[0].main
$alerts = if ($weatherData.alerts) { $weatherData.alerts.event -join ", " } else { "" }

# Determine Season
$month = (Get-Date).Month
$season = switch ($month) {
    {$_ -in 3..5} { "spring" }
    {$_ -in 6..8} { "summer" }
    {$_ -in 9..11} { "autumn" }
    default { "winter" }
}

# Map Weather Conditions to Wallpapers
$wallpaperFile = switch ($weatherCondition) {
    "Clear"        { "sunny.jpg" }
    "Clouds"       { "cloudy.jpg" }
    "Rain"         { "thunderstorm.jpg" }
    "Drizzle"      { "thunderstorm.jpg" }
    "Thunderstorm" { "thunderstorm.jpg" }
    "Snow"         { "winter.jpg" }
    "Mist"         { "cloudy.jpg" }
    "Fog"          { "cloudy.jpg" }
    "Haze"         { "cloudy.jpg" }
    "Squall"       { "windy.jpg" }
    "Tornado"      { "tornado.jpg" }
    default        { "$season.jpg" }
}

# Override for Severe Weather Alerts
if ($alerts -match "Tornado Warning|Tornado Watch") {
    $wallpaperFile = "tornado.jpg"
} elseif ($alerts -match "Winter Storm Warning|Winter Storm Watch") {
    $wallpaperFile = "winterstorm.jpg"
} elseif ($alerts -match "Flood Warning|Flood Watch") {
    $wallpaperFile = "flood.jpg"
}

# Full Path to the Selected Wallpaper
$selectedWallpaper = "$wallpaperPath/$wallpaperFile"

# Set Wallpaper Based on OS
$os = $PSVersionTable.OS

if ($os -match "Windows") {
    # Windows: Update registry and refresh wallpaper
    $RegPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $RegPath -Name WallPaper -Value $selectedWallpaper
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
    Write-Output "Windows wallpaper updated to: $selectedWallpaper"
}
elseif ($os -match "Darwin") {
    # macOS: Use AppleScript to update wallpaper
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$selectedWallpaper\""
    Write-Output "macOS wallpaper updated to: $selectedWallpaper"
}
elseif ($os -match "Linux") {
    # Linux: Try common desktop environments (GNOME, KDE, XFCE)
    if ($env:DESKTOP_SESSION -match "gnome|ubuntu") {
        gsettings set org.gnome.desktop.background picture-uri "file://$selectedWallpaper"
    } elseif ($env:DESKTOP_SESSION -match "kde") {
        qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "var allDesktops = desktops(); for (var i = 0; i < allDesktops.length; i++) { allDesktops[i].wallpaperPlugin = 'org.kde.image'; allDesktops[i].currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General']; allDesktops[i].writeConfig('Image', 'file://$selectedWallpaper'); }"
    } elseif ($env:DESKTOP_SESSION -match "xfce") {
        xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "$selectedWallpaper"
    }
    Write-Output "Linux wallpaper updated to: $selectedWallpaper"
} else {
    Write-Output "Unsupported OS: Cannot update wallpaper."
}

Write-Output "Wallpaper set successfully!"
