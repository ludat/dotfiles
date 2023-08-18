#!/bin/bash

set -euo pipefail
set -x
#
xdotool sleep 0.5 type --clearmodifiers -- "$(xclip -selection primary -out | bc -l -i -q | tail -1)"

# keystroke="$1"
# expression=$(xclip -o -selection primary)
# result=$(echo "scale=4;$expression" | bc)
#
# xdotool keyup "$keystroke"
# xdotool type --clearmodifiers --delay 0 -- "$result"
# xdotool keyup "$keystroke"
