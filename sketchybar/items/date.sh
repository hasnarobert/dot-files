#!/usr/bin/env sh

# Items at position=right stack from the bar edge inward.
# clock.sh is sourced before this file so the clock sits at the bottom edge.
# Items in this file are added in bottom-to-top order: divider → month → day → dow.

sketchybar --add item    divider.date right                        \
           --set divider.date                                       \
                  icon.drawing=off                                  \
                  label="━━━"                                       \
                  label.font="Hack Nerd Font Mono:Bold:12.0"        \
                  label.color=0xff6e738d                            \
                  padding_left=14                                   \
                  padding_right=14

sketchybar --add item    date.month right                          \
           --set date.month                                         \
                  update_freq=300                                   \
                  script="$PLUGIN_DIR/dateinfo.sh %b"               \
                  icon.drawing=off                                  \
                  label.color=0xff5c6370                            \
                  label.padding_left=0                              \
                  label.padding_right=0

sketchybar --add item    date.day right                            \
           --set date.day                                           \
                  update_freq=300                                   \
                  script="$PLUGIN_DIR/dateinfo.sh %d"               \
                  icon.drawing=off                                  \
                  label.color=0xff5c6370                            \
                  label.padding_left=0                              \
                  label.padding_right=0

sketchybar --add item    date.dow right                            \
           --set date.dow                                           \
                  update_freq=300                                   \
                  script="$PLUGIN_DIR/dateinfo.sh %a"               \
                  icon.drawing=off                                  \
                  label.color=0xff5c6370                            \
                  label.padding_left=0                              \
                  label.padding_right=0
