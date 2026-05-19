#!/usr/bin/env sh

sketchybar --add event aerospace_workspace_change

# Atom One Dark palette for the workspace section
ICON_ACTIVE=0xffabb2bf       # bright number / app icons for the focused workspace
ICON_INACTIVE=0xff5c6370     # dim number / app icons for inactive workspaces
RAIL_COLOR=0xffe06c75        # red rail on the focused workspace
TRANSPARENT=0x00000000
MAX_SLOTS=10

for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item "space.$sid" left                                  \
               --subscribe "space.$sid" aerospace_workspace_change           \
               --subscribe "space.$sid" front_app_switched                   \
               --set "space.$sid"                                            \
                              icon="▏"                                       \
                              icon.font="$FONT:Heavy:28.0"                   \
                              icon.color=$TRANSPARENT                        \
                              icon.padding_left=2                            \
                              icon.padding_right=10                          \
                              label="$sid"                                   \
                              label.font="$FONT:Bold:17.0"                   \
                              label.color=$ICON_INACTIVE                    \
                              label.padding_left=0                           \
                              label.padding_right=17                         \
                              padding_left=12                                \
                              padding_right=4                                \
                              background.drawing=off                         \
               click_script="aerospace workspace $sid"                       \
               script="$CONFIG_DIR/plugins/aerospacer.sh $sid"

    slot=1
    while [ $slot -le $MAX_SLOTS ]; do
        sketchybar --add item "space.$sid.win.$slot" left                          \
                   --set "space.$sid.win.$slot"                                    \
                                  drawing=off                                      \
                                  icon=":default:"                                 \
                                  icon.font="sketchybar-app-font:Regular:16.0"     \
                                  icon.color=$ICON_INACTIVE                        \
                                  icon.padding_left=14                             \
                                  icon.padding_right=14                            \
                                  label.drawing=off                                \
                                  background.drawing=off                           \
                   click_script="aerospace workspace $sid"
        slot=$((slot + 1))
    done
done

sketchybar --add item       separator left                                   \
           --set separator  icon=                                           \
                            icon.font="Hack Nerd Font Mono:Regular:16.0"     \
                            background.padding_left=15                       \
                            background.padding_right=15                      \
                            label.drawing=off                                \
                            associated_display=active                        \
                            icon.color=$WHITE

sketchybar --trigger aerospace_workspace_change \
    FOCUSED_WORKSPACE="$(aerospace list-workspaces --focused 2>/dev/null)"
