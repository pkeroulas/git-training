#!/usr/bin/env bash

# Function to print a file with a vertical Blue -> Red gradient
print_gradient() {
    local file="$1"
    local lines
    lines=$(wc -l < "$file")

    # Avoid division by zero if file has 0 or 1 line
    local denominator=1
    if (( lines > 1 )); then
        denominator=$(( lines - 1 ))
    fi

    local line_num=0
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Calculate Red (0 -> 255) and Blue (255 -> 0)
        local r=$(( line_num * 255 / denominator ))
        local b=$(( 255 - r ))
        local g=0

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
    print_gradient "$file"
    sleep 0.5
done