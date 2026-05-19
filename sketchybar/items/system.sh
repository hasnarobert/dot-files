#!/usr/bin/env sh

# Items at position=right stack from the bar edge inward.
# date.sh is sourced before this file, so its items are below.
# Items in this file are added in bottom-to-top order:
#   divider.system → battery → memory → cpu.

sketchybar --add item    divider.system right                      \
           --set divider.system                                     \
                  icon.drawing=off                                  \
                  label="━━━"                                       \
                  label.font="Hack Nerd Font Mono:Bold:12.0"        \
                  label.color=0xff6e738d                            \
                  padding_left=14                                   \
                  padding_right=14

sketchybar --add item    system.battery right                      \
           --set system.battery                                     \
                  update_freq=60                                    \
                  script="$PLUGIN_DIR/battery.sh"                   \
                  icon.font="Hack Nerd Font Mono:Bold:14.0"         \
                  icon.padding_left=4                               \
                  icon.padding_right=2                              \
                  label.font="Hack Nerd Font Mono:Bold:13.0"        \
                  label.padding_left=0                              \
                  label.padding_right=2

sketchybar --add item    system.memory right                       \
           --set system.memory                                      \
                  update_freq=10                                    \
                  script="$PLUGIN_DIR/memory.sh"                    \
                  icon="􀫪"                                         \
                  icon.font="$FONT:Bold:14.0"                       \
                  icon.padding_left=4                               \
                  icon.padding_right=2                              \
                  label.font="Hack Nerd Font Mono:Bold:13.0"        \
                  label.padding_left=0                              \
                  label.padding_right=2

sketchybar --add item    system.cpu right                          \
           --set system.cpu                                         \
                  update_freq=5                                     \
                  script="$PLUGIN_DIR/cpu.sh"                       \
                  icon="􀫥"                                         \
                  icon.font="$FONT:Bold:14.0"                       \
                  icon.padding_left=4                               \
                  icon.padding_right=2                              \
                  label.font="Hack Nerd Font Mono:Bold:13.0"        \
                  label.padding_left=0                              \
                  label.padding_right=2
