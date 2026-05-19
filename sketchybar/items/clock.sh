#!/usr/bin/env sh

sketchybar --add item    clock right                       \
           --set clock   update_freq=10                    \
                         script="$PLUGIN_DIR/clock.sh"     \
                         icon.padding_left=0               \
                         icon.padding_right=0              \
                         label.color=0xffe06c75            \
                         label.padding_left=-2             \
                         label.padding_right=0             \
                         background.padding_left=0         \
                         background.padding_right=0
