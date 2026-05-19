#!/bin/sh
# Use vm_stat: memory used = active + wired + compressed (as fraction of total)
PAGE_SIZE=$(vm_stat | awk '/page size of/ {print $8}')
[ -z "$PAGE_SIZE" ] && PAGE_SIZE=16384

read FREE ACTIVE INACTIVE WIRED COMPRESSED <<EOF
$(vm_stat | awk '
  /Pages free/                    {gsub(/\./,""); free=$3}
  /Pages active/                  {gsub(/\./,""); active=$3}
  /Pages inactive/                {gsub(/\./,""); inactive=$3}
  /Pages wired down/              {gsub(/\./,""); wired=$4}
  /Pages occupied by compressor/  {gsub(/\./,""); comp=$5}
  END {print free, active, inactive, wired, comp}
')
EOF

TOTAL=$((FREE + ACTIVE + INACTIVE + WIRED + COMPRESSED))
USED=$((ACTIVE + WIRED + COMPRESSED))
PCT=$((USED * 100 / TOTAL))

if [ "$PCT" -lt 60 ]; then
  COLOR=0xff98c379
elif [ "$PCT" -lt 85 ]; then
  COLOR=0xffe5c07b
else
  COLOR=0xffe06c75
fi

sketchybar --set "$NAME" label="${PCT}%" icon.color=$COLOR label.color=$COLOR
