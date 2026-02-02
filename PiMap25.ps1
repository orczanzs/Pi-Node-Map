# ------------------------------------------------------------
# Pi Node – Global Connection Visualizer
# Version: 2.4 (Stable, modular build)
# Author: Zsolt
#
# Project description:
# This tool visualizes all active Pi Node peer connections on
# an interactive world map. It detects INBOUND and OUTBOUND
# TCP connections on ports 31400–31409, retrieves geolocation
# data for each peer, and displays them with markers and lines.
#
# Script structure (4 modules):
#   1) Data Collection
#      - TCP connection scanning
#      - Direction detection (IN/OUT)
#      - Geolocation lookup
#      - My_Node external IP detection
#
#   2) HTML + CSS + Legend (with integrated support section)
#      - Leaflet map
#      - Redesigned legend panel
#      - Support QR integrated into legend
#      - Auto-refresh every 15 seconds
#
#   3) Marker & Line Rendering
#      - My_Node marker
#      - Peer markers
#      - Connection lines
#
#   4) Output Generation
#      - HTML assembly
#      - File writing
#      - Browser launch
#
# ------------------------------------------------------------
# MODUL 1 — DATA COLLECTION
$ports = 31400..31409
$geoApi = "https://ipwho.is/"
$results = @()
$nodePortSet = [System.Collections.Generic.HashSet[int]]::new()
$ports | ForEach-Object { [void]$nodePortSet.Add($_) }

Write-Host "Collecting connections..."

# My external IP (My_Node)
try {
    $myIpResp = Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -TimeoutSec 5 -ErrorAction Stop
    $myIP = $myIpResp.ip
    Write-Host "Your external IP (My_Node): $myIP"

    $myGeo = Invoke-RestMethod -Uri ($geoApi + $myIP) -TimeoutSec 5 -ErrorAction Stop
    if (-not $myGeo.success) { $myGeo = $null }
} catch {
    Write-Host "Could not detect your external IP or geolocation."
    $myIP = $null
    $myGeo = $null
}

foreach ($port in $ports) {
    $conns = Get-NetTCPConnection -State Established -ErrorAction SilentlyContinue |
             Where-Object { $_.LocalPort -eq $port -or $_.RemotePort -eq $port }

    foreach ($c in $conns) {

        $ip = $c.RemoteAddress

        # Exclude IPv6 and invalid IPs
        if (-not $ip -or $ip -match ":" -or $ip -eq "0.0.0.0") {
            continue
        }

        # Direction detection
        if ($nodePortSet.Contains($c.LocalPort) -and -not $nodePortSet.Contains($c.RemotePort)) {
            $direction = "INBOUND"
            $usedPort  = $c.LocalPort
        } elseif ($nodePortSet.Contains($c.RemotePort) -and -not $nodePortSet.Contains($c.LocalPort)) {
            $direction = "OUTBOUND"
            $usedPort  = $c.RemotePort
        } else {
            $direction = "INBOUND"
            $usedPort  = $c.LocalPort
        }

        # Geolocation
        try {
            $geo = Invoke-RestMethod -Uri ($geoApi + $ip) -TimeoutSec 5 -ErrorAction Stop

            if ($geo.success -eq $true) {
                $results += [PSCustomObject]@{
                    IP        = $ip
                    Port      = $usedPort
                    Direction = $direction
                    Country   = $geo.country
                    City      = $geo.city
                    Lat       = $geo.latitude
                    Lon       = $geo.longitude
                    Flag      = $geo.flag.emoji
                    Timezone  = $geo.timezone.id
					LocalTime = [TimeZoneInfo]::ConvertTimeBySystemTimeZoneId(
						[DateTime]::UtcNow,
						$geo.timezone.id
)
			
                }
            }

        } catch {
            Write-Host "API error: $ip"
        }
    }
}

    

# MODUL 2 — HTML + CSS + LEGEND + SUPPORT
Write-Host "Generating map..."

$html = @"
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Pi Node – Connections map</title>

<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>

<style>
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
        overflow: hidden;
        background: #1e1e1e;
        font-family: Arial, sans-serif;
    }

    #map {
        height: 100vh;
        width: 100%;
    }

    .legend-box {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 9999;
        background: white;
        padding: 14px 16px;
        border-radius: 10px;
        box-shadow: 0 0 8px rgba(0,0,0,0.35);
        font-size: 14px;
        line-height: 1.45;
        width: 240px;
    }

    .legend-separator {
        margin: 10px 0;
        border-bottom: 1px solid #ccc;
    }

    .node-label {
        color: gold;
        font-weight: bold;
        font-size: 6px;
        text-shadow: 1px 1px 2px black;
    }
</style>
</head>

<body>

<div id="map"></div>

<div class="legend-box">
    <b>Legend</b><br>
    🟢 INBOUND connections<br>
    🔵 OUTBOUND connections<br>
	<span style="display:inline-block;
             width:12px;
             height:12px;
             border-radius:50%;
             background:red;
             border:2px solid red;
             margin-right:2px;"></span>
My_Node

    <div class="legend-separator"></div>

    <b>About this map</b><br>
    This tool visualizes all active Pi Node connections in real time.<br>
    Each marker represents a peer node communicating with your Pi Node.<br>

    <div class="legend-separator"></div>

    <b>Auto-refresh:</b> every 60 seconds<br>

    <div class="legend-separator"></div>

    <b>Support the Project</b><br>
    If you enjoy this tool, you can support its development<br>
    with the price of a coffee ☕<br><br>

    <a href="https://revolut.me/orczanz" target="_blank">
        <img src="qr.jpg" alt="Support QR" style="width:150px; border-radius:6px;">
    </a>

    <br><br>
    Thank you for helping this project grow!
</div>

<script>
    var map = L.map('map').setView([20, 0], 2);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        noWrap: true
    }).addTo(map);

    var nodeIcon = L.divIcon({
        className: 'node-label',
        html: 'My_Node',
        iconSize: [15, 5],
        iconAnchor: [7, 2]
    });

    setTimeout(function() {
        location.reload();
    }, 60000);

"@
#MODUL 3 — MARKEREK + VONALAK
# My_Node marker
if ($myGeo -ne $null) {
    $html += @"
    L.circleMarker([$($myGeo.latitude), $($myGeo.longitude)], {
    color: 'red',
    radius: 6,
    weight: 2
}).addTo(map)
.bindPopup("<b>My_Node</b><br>IP: $myIP<br>$($myGeo.flag.emoji) $($myGeo.country)<br>City: $($myGeo.city)<br>Timezone: $($myGeo.timezone.id)<br>Local time: $($myGeo.timezone.current_time)");

"@
}


# Peer markers + lines
foreach ($r in $results) {

    $color = if ($r.Direction -eq "INBOUND") { "green" } else { "blue" }

    $popup = "IP: $($r.IP)<br>" +
         "Direction: $($r.Direction)<br>" +
         "Country: $($r.Country) $($r.Flag)<br>" +
         "City: $($r.City)<br>" +
         "Port: $($r.Port)<br>" +
         "Timezone: $($r.Timezone)<br>" +
         "Local time: $([string]$r.LocalTime)"



    $html += @"
    L.circleMarker([$($r.Lat), $($r.Lon)], {
        color: '$color',
        radius: 6
    }).addTo(map).bindPopup("$popup");
"@

    if ($myGeo -ne $null) {
        $html += @"
    L.polyline([
        [$($myGeo.latitude), $($myGeo.longitude)],
        [$($r.Lat), $($r.Lon)]
    ], {
        color: '$color',
        weight: 1,
        opacity: 0.7
    }).addTo(map);
"@
    }
}

# MODUL 4 — HTML LEZARASA + MENTES
$html += @"
</script>
</body>
</html>
"@

$outFile = "$PSScriptRoot\PiNodeMap.html"

[System.IO.File]::WriteAllText(
    $outFile,
    $html,
    (New-Object System.Text.UTF8Encoding($true))
)

Write-Host "Map created: $outFile"
Start-Process $outFile
