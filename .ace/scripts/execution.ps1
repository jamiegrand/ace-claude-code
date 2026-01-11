# Ace Execution Progress Display
# Shows real-time Team Lead activity during plan execution

param(
    [string]$PlanName = "Current Plan",
    [string]$Phase = "1",
    [string]$AlphaTask = "",
    [string]$BetaTask = "",
    [string]$GammaTask = "",
    [ValidateSet("Starting", "Running", "Complete", "Error")]
    [string]$Mode = "Running"
)

$ESC = [char]27
$Host.UI.RawUI.WindowTitle = "Ace - Executing"

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
    Blue       = "$ESC[38;5;75m"
}

# Spinner frames
$Spinners = @('⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏')

function Show-Header {
    Write-Host ""
    Write-Host "  $($C.Purple)╔══════════════════════════════════════════════════════════════╗$($C.Reset)"
    Write-Host "  $($C.Purple)║$($C.Reset)           $($C.Pink)$($C.Bold)ACE EXECUTE$($C.Reset)                                     $($C.Purple)║$($C.Reset)"
    Write-Host "  $($C.Purple)╠══════════════════════════════════════════════════════════════╣$($C.Reset)"
    Write-Host "  $($C.Purple)║$($C.Reset)  Phase: $($C.Bold)$Phase$($C.Reset)  │  Plan: $($C.Cyan)$PlanName$($C.Reset)" + (" " * (35 - $PlanName.Length)) + "$($C.Purple)║$($C.Reset)"
    Write-Host "  $($C.Purple)╚══════════════════════════════════════════════════════════════╝$($C.Reset)"
    Write-Host ""
}

function Show-TeamBox {
    param(
        [string]$Name,
        [string]$Task,
        [string]$Status,
        [string]$Color,
        [int]$SpinnerIndex
    )

    $statusIcon = switch ($Status) {
        "WORKING" { "$($C.Yellow)$($Spinners[$SpinnerIndex])$($C.Reset)" }
        "DONE"    { "$($C.Green)✓$($C.Reset)" }
        "ERROR"   { "$($C.Red)✗$($C.Reset)" }
        "WAITING" { "$($C.Gray)○$($C.Reset)" }
        default   { "$($C.Gray)·$($C.Reset)" }
    }

    $truncTask = if ($Task.Length -gt 18) { $Task.Substring(0, 15) + "..." } else { $Task }
    $taskPad = 18 - $truncTask.Length
    if ($taskPad -lt 0) { $taskPad = 0 }

    Write-Host "  $Color┌──────────────────────┐$($C.Reset)"
    Write-Host "  $Color│$($C.Reset) $($C.Bold)$Name$($C.Reset)" + (" " * (13 - $Name.Length)) + "$statusIcon     $Color│$($C.Reset)"
    Write-Host "  $Color├──────────────────────┤$($C.Reset)"
    Write-Host "  $Color│$($C.Reset) $($C.Gray)$truncTask$($C.Reset)" + (" " * $taskPad) + " $Color│$($C.Reset)"
    Write-Host "  $Color└──────────────────────┘$($C.Reset)"
}

function Show-ExecutionGrid {
    param(
        [string]$AlphaStatus,
        [string]$BetaStatus,
        [string]$GammaStatus,
        [int]$Frame
    )

    $spinIdx = $Frame % $Spinners.Length

    Write-Host "  $($C.Bold)TASK DISTRIBUTION:$($C.Reset)"
    Write-Host ""

    # Draw three boxes side by side (simplified to vertical for PS)
    $boxes = @(
        @{ Name = "ALPHA"; Task = $AlphaTask; Status = $AlphaStatus; Color = $C.Blue },
        @{ Name = "BETA"; Task = $BetaTask; Status = $BetaStatus; Color = $C.Green },
        @{ Name = "GAMMA"; Task = $GammaTask; Status = $GammaStatus; Color = $C.Pink }
    )

    # Header row
    Write-Host "  $($C.Blue)┌──────────────────────┐$($C.Reset)  $($C.Green)┌──────────────────────┐$($C.Reset)  $($C.Pink)┌──────────────────────┐$($C.Reset)"

    # Name row
    $alphaIcon = if ($AlphaStatus -eq "WORKING") { "$($C.Yellow)$($Spinners[$spinIdx])$($C.Reset)" } elseif ($AlphaStatus -eq "DONE") { "$($C.Green)✓$($C.Reset)" } else { "$($C.Gray)○$($C.Reset)" }
    $betaIcon = if ($BetaStatus -eq "WORKING") { "$($C.Yellow)$($Spinners[$spinIdx])$($C.Reset)" } elseif ($BetaStatus -eq "DONE") { "$($C.Green)✓$($C.Reset)" } else { "$($C.Gray)○$($C.Reset)" }
    $gammaIcon = if ($GammaStatus -eq "WORKING") { "$($C.Yellow)$($Spinners[$spinIdx])$($C.Reset)" } elseif ($GammaStatus -eq "DONE") { "$($C.Green)✓$($C.Reset)" } else { "$($C.Gray)○$($C.Reset)" }

    Write-Host "  $($C.Blue)│$($C.Reset) $($C.Bold)ALPHA$($C.Reset)         $alphaIcon     $($C.Blue)│$($C.Reset)  $($C.Green)│$($C.Reset) $($C.Bold)BETA$($C.Reset)          $betaIcon     $($C.Green)│$($C.Reset)  $($C.Pink)│$($C.Reset) $($C.Bold)GAMMA$($C.Reset)         $gammaIcon     $($C.Pink)│$($C.Reset)"

    # Separator
    Write-Host "  $($C.Blue)├──────────────────────┤$($C.Reset)  $($C.Green)├──────────────────────┤$($C.Reset)  $($C.Pink)├──────────────────────┤$($C.Reset)"

    # Task row (truncated)
    $at = if ($AlphaTask.Length -gt 18) { $AlphaTask.Substring(0, 15) + "..." } else { $AlphaTask }
    $bt = if ($BetaTask.Length -gt 18) { $BetaTask.Substring(0, 15) + "..." } else { $BetaTask }
    $gt = if ($GammaTask.Length -gt 18) { $GammaTask.Substring(0, 15) + "..." } else { $GammaTask }

    $atPad = 20 - $at.Length; if ($atPad -lt 0) { $atPad = 0 }
    $btPad = 20 - $bt.Length; if ($btPad -lt 0) { $btPad = 0 }
    $gtPad = 20 - $gt.Length; if ($gtPad -lt 0) { $gtPad = 0 }

    Write-Host "  $($C.Blue)│$($C.Reset) $($C.Gray)$at$($C.Reset)$(" " * $atPad)$($C.Blue)│$($C.Reset)  $($C.Green)│$($C.Reset) $($C.Gray)$bt$($C.Reset)$(" " * $btPad)$($C.Green)│$($C.Reset)  $($C.Pink)│$($C.Reset) $($C.Gray)$gt$($C.Reset)$(" " * $gtPad)$($C.Pink)│$($C.Reset)"

    # Bottom
    Write-Host "  $($C.Blue)└──────────────────────┘$($C.Reset)  $($C.Green)└──────────────────────┘$($C.Reset)  $($C.Pink)└──────────────────────┘$($C.Reset)"
}

function Show-ProgressBar {
    param([int]$Done, [int]$Total)

    $percent = if ($Total -gt 0) { [math]::Floor(($Done / $Total) * 100) } else { 0 }
    $width = 50
    $filled = [math]::Floor(($percent / 100) * $width)
    $empty = $width - $filled

    $bar = "$($C.Green)" + ("█" * $filled) + "$($C.Gray)" + ("░" * $empty) + "$($C.Reset)"
    Write-Host ""
    Write-Host "  Progress: [$bar] $Done/$Total ($percent%)"
}

function Show-ExecutionView {
    param(
        [string]$AlphaStatus = "WAITING",
        [string]$BetaStatus = "WAITING",
        [string]$GammaStatus = "WAITING",
        [int]$Frame = 0
    )

    Clear-Host
    Show-Header
    Show-ExecutionGrid -AlphaStatus $AlphaStatus -BetaStatus $BetaStatus -GammaStatus $GammaStatus -Frame $Frame

    $done = 0
    if ($AlphaStatus -eq "DONE") { $done++ }
    if ($BetaStatus -eq "DONE") { $done++ }
    if ($GammaStatus -eq "DONE") { $done++ }

    Show-ProgressBar -Done $done -Total 3
    Write-Host ""
    Write-Host "  $($C.Dim)Execution: PARALLEL$($C.Reset)"
}

# Demo/Test mode
if ($Mode -eq "Running") {
    # Animated demo
    $statuses = @("WAITING", "WORKING", "DONE")

    for ($i = 0; $i -lt 30; $i++) {
        $alphaS = if ($i -lt 5) { "WAITING" } elseif ($i -lt 15) { "WORKING" } else { "DONE" }
        $betaS = if ($i -lt 8) { "WAITING" } elseif ($i -lt 20) { "WORKING" } else { "DONE" }
        $gammaS = if ($i -lt 3) { "WAITING" } elseif ($i -lt 25) { "WORKING" } else { "DONE" }

        Show-ExecutionView -AlphaStatus $alphaS -BetaStatus $betaS -GammaStatus $gammaS -Frame $i
        Start-Sleep -Milliseconds 200
    }

    # Final state
    Show-ExecutionView -AlphaStatus "DONE" -BetaStatus "DONE" -GammaStatus "DONE" -Frame 0
    Write-Host ""
    Write-Host "  $($C.Green)$($C.Bold)EXECUTION COMPLETE$($C.Reset)"
    Write-Host ""
}
