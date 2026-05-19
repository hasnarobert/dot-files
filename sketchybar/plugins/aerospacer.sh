#!/bin/bash

SID=$1
MAX_SLOTS=10
# Atom One Dark palette — must match items/spaces.sh
ICON_ACTIVE=0xffabb2bf
ICON_INACTIVE=0xff5c6370
RAIL_COLOR=0xffe06c75
TRANSPARENT=0x00000000

if [ -z "$FOCUSED_WORKSPACE" ]; then
    FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
fi

apps=()
while IFS= read -r line; do
    apps+=("$line")
done < <(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null | sort)

if [ "$SID" = "$FOCUSED_WORKSPACE" ]; then
    rail_col=$RAIL_COLOR
    icon_col=$ICON_ACTIVE
else
    rail_col=$TRANSPARENT
    icon_col=$ICON_INACTIVE
fi

sketchybar --set "space.$SID" icon.color=$rail_col label.color=$icon_col

slot=1
while [ $slot -le $MAX_SLOTS ]; do
    idx=$((slot - 1))
    app="${apps[$idx]:-}"
    item="space.$SID.win.$slot"
    if [ -n "$app" ]; then
        icon=$("$CONFIG_DIR/plugins/icon_map.sh" "$app")
        sketchybar --set "$item" icon="$icon" icon.color=$icon_col drawing=on
    else
        sketchybar --set "$item" drawing=off
    fi
    slot=$((slot + 1))
done
