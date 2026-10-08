{ pkgs, lib, ... }:

let
  iconFont = "Symbols Nerd Font:Regular:15.0";

  battery = pkgs.writeShellScript "sketchybar-battery" ''
    PERCENT=$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)
    CHARGING=$(pmset -g batt | grep "AC Power")

    [ -z "$PERCENT" ] && exit 0

    if [ -n "$CHARGING" ]; then ICON=""
    elif [ "$PERCENT" -ge 90 ]; then ICON=""
    elif [ "$PERCENT" -ge 60 ]; then ICON=""
    elif [ "$PERCENT" -ge 30 ]; then ICON=""
    elif [ "$PERCENT" -ge 10 ]; then ICON=""
    else ICON=""
    fi

    sketchybar --set "$NAME" icon="$ICON" label="$PERCENT%"
  '';
in

{
  programs.sketchybar = {
    enable = true;

    config = ''
      # basic settings
      sketchybar --bar position=top \
                       height=25 \
                       color=0x99452959 \
                       border_color=0xff2e1a40 \
                       corner_radius=10 \
                       blur_radius=20
      # item defaults (spacing between items)
      sketchybar --default padding_left=8 \
                           padding_right=8 \
                           label.padding_left=4 \
                           label.padding_right=4

      # items

      # clock item
      sketchybar --add item clock right \
                 --set clock update_freq=10 \
                       script='sketchybar --set $NAME label="$(date "+%a %d %b %H:%M")"'

      # battery
      sketchybar --add item battery right \
                 --set battery update_freq=120 \
                               icon.font="${iconFont}" \
                               script="${battery}" \
                 --subscribe battery power_source_change system_woke

      # volume
      sketchybar --add item volume right \
                 --set volume script='sketchybar --set $NAME label="vol $INFO%"' \
                 --subscribe volume volume_change

      # workspaces
      for sid in 1 2 3 4 5; do
        sketchybar --add space space.$sid left \
                   --set space.$sid space=$sid \
                                    icon=$sid \
                                    icon.padding_left=8 \
                                    icon.padding_right=8 \
                                    label.drawing=off \
                                    background.color=0xff2e1a40 \
                                    background.corner_radius=5 \
                                    background.height=20 \
                                    script='sketchybar --set $NAME background.drawing=$SELECTED'
      done

      # cpu usage
      sketchybar --add item cpu right \
                 --set cpu update_freq=5 \
                           icon= \
                           icon.font="${iconFont}" \
                           script='sketchybar --set $NAME label="$(top -l 1 | awk "/CPU usage/ {print int(\$3)}")%"'


      sketchybar --update
    '';
  };

  # icon font used by the bar
  home.packages = with pkgs; [
    nerd-fonts.symbols-only
  ];
}
