#!/bin/sh
USAGE=$(top -l 2 -s 0 -n 0 | grep "CPU usage" | tail -1 | awk '{
  gsub(/%/, "");
  print int($3 + $5)
}')

if [ "$USAGE" -lt 50 ]; then
  COLOR=0xff98c379
elif [ "$USAGE" -lt 80 ]; then
  COLOR=0xffe5c07b
else
  COLOR=0xffe06c75
fi

sketchybar --set "$NAME" label="${USAGE}%" icon.color=$COLOR label.color=$COLOR
