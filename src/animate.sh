#!/usr/bin/env bash

# Function to print a file with a vertical gradient between two Hex colors
# Usage: print_gradient "file.txt" "#HEX1" "#HEX2"
print_gradient() {
    local file="$1"
    local c1_hex="${2:-#00A0A0}" # Default start: Cyan
    local c2_hex="${3:-#FF0000}" # Default end: Red

    # Strip leading '#' if present
    c1_hex="${c1_hex###}"
    c2_hex="${c2_hex###}"

    # Parse Start RGB components (hex to decimal)
    local r1=$(( 16#${c1_hex:0:2} ))
    local g1=$(( 16#${c1_hex:2:2} ))
    local b1=$(( 16#${c1_hex:4:2} ))

    # Parse End RGB components (hex to decimal)
    local r2=$(( 16#${c2_hex:0:2} ))
    local g2=$(( 16#${c2_hex:2:2} ))
    local b2=$(( 16#${c2_hex:4:2} ))

    local lines
    lines=$(wc -l < "$file")

    local denominator=1
    if (( lines > 1 )); then
        denominator=$(( lines - 1 ))
    fi

    local line_num=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Interpolate R, G, B linearly between start and end
        local r=$(( r1 + (r2 - r1) * line_num / denominator ))
        local g=$(( g1 + (g2 - g1) * line_num / denominator ))
        local b=$(( b1 + (b2 - b1) * line_num / denominator ))

        # Print with 24-bit ANSI color
        printf "\e[38;2;%d;%d;%dm%s\e[0m\n" "$r" "$g" "$b" "$line"
        (( line_num++ ))
    done < "$file"
}

# --- Main Script ---

dir="${1:-.}"

if [[ ! -d "$dir" ]]; then
    echo "Error: Directory '$dir' does not exist." >&2
    exit 1
fi

# Enable natural sorting (1.txt, 2.txt ... 10.txt)
shopt -s version_sort nullglob

files=("$dir"/*.txt)

if (( ${#files[@]} == 0 )); then
    echo "No .txt files found in '$dir'."
    exit 0
fi

for file in "${files[@]}"; do
    clear
    print_gradient "$file" "#0000FF" "#FF0000"
    sleep 0.5
done