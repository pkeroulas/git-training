#!/usr/bin/env bash

dir="${1:-.}"
if [[ ! -d "$dir" ]]; then
    echo "Error: Directory '$dir' does not exist." >&2
    exit 1
fi

for i in $(seq 1 16); do
    index=$(printf "%02d\n" "$i")
    file="$dir/$index.txt"
    cp "$dir/0.txt" "$file"
    echo $index >> "$file"
    cat "$file"
done