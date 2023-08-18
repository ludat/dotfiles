#!/bin/bash

set -euo pipefail
set -x

firefox_window="$(xdotool search youtube)"

while sleep 1; do
  player_id="$(playerctl -l | grep firefox)"
  if [[ $(playerctl status --player=$player_id) = Paused ]]; then
    xdotool key --window=$firefox_window ctrl+w
  fi

done
