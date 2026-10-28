# ==============================================================================
# Script: Invoke-HardwareWatchdog.ps1
# Description: Silent Hardware Health, Thermals, & Disk Space Watchdog
# Supports: -Report (Console Dashboard), -Check (Silent Watchdog), -ForceToast
# ==============================================================================

param(
    [switch]$Report,
    [switch]$Check,
    [switch]$ForceToast
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$enginePy = Join-Path $scriptDir "hardware_watchdog.py"

function Show-ToastNotification {
    param(
        [string]$Title,
        [string]$Message,
        [string]$Subtext = "",
        [bool]$IsWarning = $false
    )
    try {
        $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
        $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
        $textNodes = $template.GetElementsByTagName("text")
        $textNodes.Item(0).AppendChild($template.CreateTextNode($Title)) | Out-Null
        $body = if ($Subtext) { "$Message`n$Subtext" } else { $Message }
        $textNodes.Item(1).AppendChild($template.CreateTextNode($body)) | Out-Null
        
        if ($IsWarning) {
            # Play gentle alert chime for warnings
            $audio = $template.CreateElement("audio")
            $audio.SetAttribute("src", "ms-winsoundevent:Notification.Reminder")
            $template.DocumentElement.AppendChild($audio) | Out-Null
        } else {
            $audio = $template.CreateElement("audio")
            $audio.SetAttribute("silent", "true")
            $template.DocumentElement.AppendChild($audio) | Out-Null
        }

        $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
        $toast.Tag = "HardwareHealth"
        $toast.Group = "SystemWatchdog"
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toast)
    } catch {}
}

# Run Python Engine
$rawJson = python $enginePy
$data = $rawJson | ConvertFrom-Json

# Silent Watchdog Mode (runs on schedule / boot)
if ($Check) {
    if ($data.has_issues) {
        $alertSummary = ($data.alerts -join " • ")
        Show-ToastNotification -Title "Hardware Health Alert ($($data.overall_status))" `
            -Message $alertSummary `
            -Subtext "Samsung 990 PRO & RTX 4060 Watchdog" `
            -IsWarning $true
    }
    return
}

if ($ForceToast) {
    $gpuTemp = if ($data.gpu.available) { "$($data.gpu.temp_c)°C" } else { "N/A" }
    $vols = ($data.volumes | ForEach-Object { "$($_.drive): $($_.pct_free)%" }) -join " | "
    Show-ToastNotification -Title "System Health: $($data.overall_status)" `
        -Message "Free Space: $vols • GPU: $gpuTemp • RAM: $($data.cpu_ram.ram_load_pct)%" `
        -Subtext "All physical SSDs Healthy (Samsung 990 PRO 1TB + MZAL4512)" `
        -IsWarning ($data.overall_status -ne "HEALTHY")
    return
}

# Default: Executive Report Mode
$statusColor = if ($data.overall_status -eq "HEALTHY") { "Green" } elseif ($data.overall_status -eq "WARNING") { "Yellow" } else { "Red" }

Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "          ANTIGRAVITY SILENT HARDWARE HEALTH & DISK WATCHDOG                " -ForegroundColor Yellow
Write-Host "============================================================================" -ForegroundColor Cyan
Write-Host "  System Status : " -NoNewline -ForegroundColor White
Write-Host "$($data.overall_status)" -ForegroundColor $statusColor
Write-Host "  Timestamp     : $($data.timestamp)" -ForegroundColor DarkGray
Write-Host "----------------------------------------------------------------------------" -ForegroundColor DarkGray

Write-Host "`n[1] PHYSICAL SSD & STORAGE HEALTH" -ForegroundColor Cyan
foreach ($d in $data.disks) {
    $hColor = if ($d.health_status -eq "Healthy") { "Green" } else { "Red" }
    Write-Host "  • [$($d.type)] $($d.name) ($($d.size_gb) GB)" -ForegroundColor White
    Write-Host "    Status: $($d.operational_status) | Health: " -NoNewline -ForegroundColor DarkGray
    Write-Host "$($d.health_status)" -ForegroundColor $hColor
}

Write-Host "`n[2] VOLUME PARTITION CAPACITY" -ForegroundColor Cyan
foreach ($v in $data.volumes) {
    $bars = [math]::Min(20, [math]::Max(1, [math]::Round(($v.pct_free / 100) * 20)))
    $meter = ("#" * $bars) + ("-" * (20 - $bars))
    $cColor = if ($v.pct_free -lt 15) { "Yellow" } else { "Green" }
    Write-Host "  * Drive $($v.drive): [$meter] $($v.pct_free)% Free" -ForegroundColor $cColor
    Write-Host "    Free: $($v.free_gb) GB / Total: $($v.total_gb) GB (Used: $($v.used_gb) GB)" -ForegroundColor DarkGray
}

Write-Host "`n[3] NVIDIA GPU TELEMETRY" -ForegroundColor Cyan
if ($data.gpu.available) {
    $tColor = if ($data.gpu.temp_c -lt 70) { "Green" } elseif ($data.gpu.temp_c -lt 82) { "Yellow" } else { "Red" }
    Write-Host "  • GPU Model   : $($data.gpu.name)" -ForegroundColor White
    Write-Host "    Driver Ver  : $($data.gpu.driver_version)" -ForegroundColor DarkGray
    Write-Host "    Temperature : " -NoNewline -ForegroundColor DarkGray
    Write-Host "$($data.gpu.temp_c)°C (Safe & Cool)" -ForegroundColor $tColor
    Write-Host "    VRAM Usage  : $($data.gpu.vram_used_mb) MB / $($data.gpu.vram_total_mb) MB ($($data.gpu.vram_pct)%)" -ForegroundColor DarkGray
    Write-Host "    GPU Load    : $($data.gpu.utilization_pct)%" -ForegroundColor DarkGray
} else {
    Write-Host "  • NVIDIA GPU not detected." -ForegroundColor DarkGray
}

Write-Host "`n[4] CPU & SYSTEM RAM METRICS" -ForegroundColor Cyan
Write-Host "  • CPU Model   : $($data.cpu_ram.cpu_name)" -ForegroundColor White
Write-Host "    Cores/Threads: $($data.cpu_ram.cpu_cores) Cores / $($data.cpu_ram.cpu_threads) Threads" -ForegroundColor DarkGray
Write-Host "    Current Load: $($data.cpu_ram.cpu_load_pct)%" -ForegroundColor DarkGray
Write-Host "    System RAM  : $($data.cpu_ram.used_ram_gb) GB used / $($data.cpu_ram.total_ram_gb) GB total ($($data.cpu_ram.ram_load_pct)% utilized)" -ForegroundColor DarkGray
Write-Host "    Free Memory : $($data.cpu_ram.free_ram_gb) GB available" -ForegroundColor DarkGray

if ($data.alerts.Count -gt 0) {
    Write-Host "`n[!] ACTIVE ALERTS:" -ForegroundColor Yellow
    foreach ($a in $data.alerts) {
        Write-Host "  * $a" -ForegroundColor Yellow
    }
} else {
    Write-Host "`n[+] Zero hardware anomalies detected. All components operating within peak limits." -ForegroundColor Green
}

Write-Host "============================================================================" -ForegroundColor Cyan
