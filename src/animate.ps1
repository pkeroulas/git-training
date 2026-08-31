param (
    [string]$Directory = "."
)

# Function to print a file with a vertical Blue -> Red gradient
function Print-Gradient {
    param (
        [string]$FilePath
    )

    $lines = Get-Content -Path $FilePath
    $totalLines = $lines.Count

    # Avoid division by zero if file has 0 or 1 line
    $denominator = 1
    if ($totalLines -gt 1) {
        $denominator = $totalLines - 1
    }

    $lineNum = 0
    foreach ($line in $lines) {
        # Calculate Red (0 -> 255) and Blue (255 -> 0)
        $r = [math]::Floor($lineNum * 255 / $denominator)
        $b = 255 - $r
        $g = 0

        # Print with 24-bit ANSI color escape sequence
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
    Print-Gradient -FilePath $file.FullName
    Start-Sleep -Seconds 0.5
}