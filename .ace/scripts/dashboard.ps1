# Ace Progress Dashboard
# Real-time execution status display

param(
    [string]$StateFile = ".ace/planning/STATE.md",
    [string]$PlanFile = "",
    [switch]$Watch,         # Continuous update mode
    [int]$RefreshRate = 2   # Seconds between updates
)

$ESC = [char]27

# Colors
$C = @{
    Reset      = "$ESC[0m"
    Bold       = "$ESC[1m"
    Dim        = "$ESC[2m"
    Purple     = "$ESC[38;5;135m"
    Pink       = "$ESC[38;5;213m"
    Green      = "$ESC[38;5;114m"
    Yellow     = "$ESC[38;5;221m"
    Red        = "$ESC[38;5;203m"
    Cyan       = "$ESC[38;5;117m"
    Gray       = "$ESC[38;5;245m"
    White      = "$ESC[38;5;255m"
    BgDark     = "$ESC[48;5;236m"
}

function Draw-Box {
    param(
        [string]$Title,
        [string[]]$Content,
        [int]$Width = 60,
        [string]$Color = $C.Purple
    )

    $top = "$Color╔" + ("═" * ($Width - 2)) + "╗$($C.Reset)"
    $titleLine = "$Color║$($C.Reset) $($C.Bold)$Title$($C.Reset)" + (" " * ($Width - 4 - $Title.Length)) + "$Color║$($C.Reset)"
    $sep = "$Color╠" + ("═" * ($Width - 2)) + "╣$($C.Reset)"
    $bottom = "$Color╚" + ("═" * ($Width - 2)) + "╝$($C.Reset)"

    Write-Host $top
    Write-Host $titleLine
    Write-Host $sep

    foreach ($line in $Content) {
        $padding = $Width - 4 - ($line -replace "$ESC\[[0-9;]*m", '').Length
        if ($padding -lt 0) { $padding = 0 }
        Write-Host "$Color║$($C.Reset) $line" + (" " * $padding) + " $Color║$($C.Reset)"
    }

    Write-Host $bottom
}

function Draw-ProgressBar {
    param(
        [int]$Percent,
        [int]$Width = 40,
        [string]$Color = $C.Green
    )

    $filled = [math]::Floor(($Percent / 100) * $Width)
    $empty = $Width - $filled

    $bar = "$Color" + ("█" * $filled) + "$($C.Gray)" + ("░" * $empty) + "$($C.Reset)"
    return "[$bar] $Percent%"
}

function Draw-TeamStatus {
    param(
        [string]$Alpha = "IDLE",
        [string]$Beta = "IDLE",
        [string]$Gamma = "IDLE"
    )

    $statusColor = @{
        "IDLE" = $C.Gray
        "WORKING" = $C.Yellow
        "DONE" = $C.Green
        "ERROR" = $C.Red
    }

    $alphaC = $statusColor[$Alpha]
    $betaC = $statusColor[$Beta]
    $gammaC = $statusColor[$Gamma]

    $lines = @(
        "$($C.Purple)┌────────────┬────────────┬────────────┐$($C.Reset)",
        "$($C.Purple)│$($C.Reset)   $($C.Bold)ALPHA$($C.Reset)    $($C.Purple)│$($C.Reset)    $($C.Bold)BETA$($C.Reset)    $($C.Purple)│$($C.Reset)   $($C.Bold)GAMMA$($C.Reset)    $($C.Purple)│$($C.Reset)",
        "$($C.Purple)├────────────┼────────────┼────────────┤$($C.Reset)",
        "$($C.Purple)│$($C.Reset)  $alphaC$Alpha$($C.Reset)" + (" " * (8 - $Alpha.Length)) + "$($C.Purple)│$($C.Reset)  $betaC$Beta$($C.Reset)" + (" " * (8 - $Beta.Length)) + "$($C.Purple)│$($C.Reset)  $gammaC$Gamma$($C.Reset)" + (" " * (8 - $Gamma.Length)) + "$($C.Purple)│$($C.Reset)",
        "$($C.Purple)└────────────┴────────────┴────────────┘$($C.Reset)"
    )

    foreach ($line in $lines) {
        Write-Host "          $line"
    }
}

function Draw-MiniCauldron {
    $cauldron = @(
        "$($C.Gray)     .  o  .$($C.Reset)",
        "$($C.Gray)    o  .  o$($C.Reset)",
        "$($C.Purple)  .d88888888b.$($C.Reset)",
        "$($C.Purple) d888888888888b$($C.Reset)",
        "$($C.Pink)888888888888888$($C.Reset)",
        "$($C.Purple) Y8888888888P$($C.Reset)",
        "$($C.Gray)  `Y888888P'$($C.Reset)",
        "$($C.Dim)   _/    \_$($C.Reset)"
    )
    return $cauldron
}

function Get-StateInfo {
    if (Test-Path $StateFile) {
        $content = Get-Content $StateFile -Raw

        # Parse basic info
        $phase = if ($content -match "Phase:\s*(\d+)\s*of\s*(\d+)") {
            @{ Current = $Matches[1]; Total = $Matches[2] }
        } else { @{ Current = "?"; Total = "?" } }

        $status = if ($content -match "Status:\s*(.+)") { $Matches[1].Trim() } else { "Unknown" }
        $lastActivity = if ($content -match "Last activity:\s*(.+)") { $Matches[1].Trim() } else { "Unknown" }

        # Parse progress percentage
        $progress = if ($content -match "Progress:.*\[([#\s]+)\]\s*(\d+)%") {
            [int]$Matches[2]
        } else { 0 }

        return @{
            Phase = $phase
            Status = $status
            LastActivity = $lastActivity
            Progress = $progress
        }
    }
    return $null
}

function Show-Dashboard {
    Clear-Host

    $state = Get-StateInfo

    # Header
    Write-Host ""
    Write-Host "  $($C.Purple)$($C.Bold)╔══════════════════════════════════════════════════════════════╗$($C.Reset)"
    Write-Host "  $($C.Purple)$($C.Bold)║$($C.Reset)              $($C.Pink)$($C.Bold)C L A U D R O N$($C.Reset)   $($C.Gray)Dashboard$($C.Reset)              $($C.Purple)$($C.Bold)║$($C.Reset)"
    Write-Host "  $($C.Purple)$($C.Bold)╚══════════════════════════════════════════════════════════════╝$($C.Reset)"
    Write-Host ""

    # Mini cauldron on the side
    $cauldron = Draw-MiniCauldron

    if ($state) {
        # Status section
        $statusContent = @(
            "$($C.Gray)Phase:$($C.Reset)    $($C.Bold)$($state.Phase.Current)$($C.Reset) of $($state.Phase.Total)",
            "$($C.Gray)Status:$($C.Reset)   $($C.Green)$($state.Status)$($C.Reset)",
            "$($C.Gray)Activity:$($C.Reset) $($state.LastActivity)",
            "",
            (Draw-ProgressBar -Percent $state.Progress -Width 45)
        )

        Draw-Box -Title "PROJECT STATUS" -Content $statusContent -Width 58 -Color $C.Purple
        Write-Host ""

        # Team Leads
        Write-Host "  $($C.Bold)TEAM LEADS$($C.Reset)"
        Draw-TeamStatus -Alpha "IDLE" -Beta "IDLE" -Gamma "IDLE"
        Write-Host ""

        # Quick commands
        $cmdContent = @(
            "$($C.Cyan)/ace:progress$($C.Reset)      Refresh status",
            "$($C.Cyan)/ace:execute-plan$($C.Reset)  Start execution",
            "$($C.Cyan)/ace:show-plan$($C.Reset)     View current plan",
            "$($C.Cyan)/ace:help$($C.Reset)          All commands"
        )
        Draw-Box -Title "QUICK COMMANDS" -Content $cmdContent -Width 58 -Color $C.Gray

    } else {
        Write-Host "  $($C.Yellow)No project state found.$($C.Reset)"
        Write-Host "  $($C.Gray)Run $($C.Cyan)/ace:new-project$($C.Gray) to start.$($C.Reset)"
    }

    Write-Host ""
    if ($Watch) {
        Write-Host "  $($C.Dim)Auto-refreshing every $RefreshRate seconds. Press Ctrl+C to exit.$($C.Reset)"
    }
}

# Main
if ($Watch) {
    while ($true) {
        Show-Dashboard
        Start-Sleep -Seconds $RefreshRate
    }
} else {
    Show-Dashboard
}
