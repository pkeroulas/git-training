param (
    [string]$Directory = ".",
    [string]$StartColor = "#0000FF",
    [string]$EndColor   = "#FF0000"
)

# Function to print a file with a vertical gradient between two Hex colors
function Print-Gradient {
    param (
        [string]$FilePath,
        [string]$C1Hex = "#0000FF",
        [string]$C2Hex = "#FF0000"
    )

    # Strip leading '#' if present
    $C1Hex = $C1Hex.TrimStart('#')
    $C2Hex = $C2Hex.TrimStart('#')

    # Parse Start RGB components (hex to decimal)
    $r1 = [System.Convert]::ToInt32($C1Hex.Substring(0, 2), 16)
    $g1 = [System.Convert]::ToInt32($C1Hex.Substring(2, 2), 16)
    $b1 = [System.Convert]::ToInt32($C1Hex.Substring(4, 2), 16)

    # Parse End RGB components (hex to decimal)
    $r2 = [System.Convert]::ToInt32($C2Hex.Substring(0, 2), 16)
    $g2 = [System.Convert]::ToInt32($C2Hex.Substring(2, 2), 16)
    $b2 = [System.Convert]::ToInt32($C2Hex.Substring(4, 2), 16)

    $lines = Get-Content -Path $FilePath
    $totalLines = $lines.Count

    # Avoid division by zero if file has 0 or 1 line
    $denominator = 1
    if ($totalLines -gt 1) {
        $denominator = $totalLines - 1
    }

    $lineNum = 0
    foreach ($line in $lines) {
        # Interpolate R, G, B linearly between start and end
        $r = [math]::Floor($r1 + ($r2 - $r1) * $lineNum / $denominator)
        $g = [math]::Floor($g1 + ($g2 - $g1) * $lineNum / $denominator)
        $b = [math]::Floor($b1 + ($b2 - $b1) * $lineNum / $denominator)

        # Print with 24-bit ANSI color
        Write-Host "$([char]27)[38;2;${r};${g};${b}m${line}$([char]27)[0m"
        $lineNum++
    }
}

# --- Main Script ---

if (-not (Test-Path -Path $Directory -PathType Container)) {
    Write-Error "Error: Directory '$Directory' does not exist."
    exit 1
}

# Get .txt files sorted naturally (1.txt, 2.txt ... 10.txt)
$files = Get-ChildItem -Path $Directory -Filter "*.txt" -File | 
         Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20, '0') }) }

if (-not $files) {
    Write-Host "No .txt files found in '$Directory'."
    exit 0
}

foreach ($file in $files) {
    Clear-Host
    Print-Gradient -FilePath $file.FullName -C1Hex $StartColor -C2Hex $EndColor
    Start-Sleep -Seconds 0.5
}