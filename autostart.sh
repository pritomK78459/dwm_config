feh --no-fehbg --bg-fill '/usr/local/src/dwm/wallpapers/wallpaper1.jpg'


cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*((total-prevtotal) - (idle-previdle) / (total-prevtotal))))
  echo  " cpu: $cpu"
}

df_check_location='/home'

dwm_resources () {
	# get all the infos first to avoid high resources usage
	free_output=$(free -h | grep Mem)
	df_output=$(df -h $df_check_location | tail -n 1)
	# Used and total memory
	MEMUSED=$(echo $free_output | awk '{print $3}')
	MEMTOT=$(echo $free_output | awk '{print $2}')
	# CPU temperature
	CPU=$(top -bn1 | grep Cpu | awk '{print $2}')%
	#CPU=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d. -f1)
	# Used and total storage in /home (rounded to 1024B)
	STOUSED=$(echo $df_output | awk '{print $3}')
	STOTOT=$(echo $df_output | awk '{print $2}')
	STOPER=$(echo $df_output | awk '{print $5}')

	if [ "$IDENTIFIER" = "unicode" ]; then
		printf "💻 MEM %s/%s CPU %s STO %s/%s: %s" "$MEMUSED" "$MEMTOT" "$CPU" "$STOUSED" "$STOTOT" "$STOPER"
	else
		printf "STA | MEM %s/%s CPU %s STO %s/%s: %s" "$MEMUSED" "$MEMTOT" "$CPU" "$STOUSED" "$STOTOT" "$STOPER"
	fi
}


dwm_battery () {
    # Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
    CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$IDENTIFIER" = "unicode" ]; then
        if [ "$STATUS" = "Charging" ]; then
            printf "🔌 %s%% %s" "$CHARGE" "$STATUS"
        else
            printf "🔋 %s%% %s" "$CHARGE" "$STATUS"
        fi
    else
        printf "BAT %s%% %s" "$CHARGE" "$STATUS"
    fi
    
}


dwm_pulse () {
    VOL=$(pamixer --get-volume)
    STATE=$(pamixer --get-mute)
    
    if [ "$IDENTIFIER" = "unicode" ]; then
        if [ "$STATE" = "true" ] || [ "$VOL" -eq 0 ]; then
            printf "🔇"
        elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
            printf "🔈 %s%%" "$VOL"
        elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
            printf "🔉 %s%%" "$VOL"
        else
            printf "🔊 %s%%" "$VOL"
        fi
    else
        if [ "$STATE" = "true" ] || [ "$VOL" -eq 0 ]; then
            printf "MUTE"
        elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
            printf "VOL %s%%" "$VOL"
        elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
            printf "VOL %s%%" "$VOL"
        else
            printf "VOL %s%%" "$VOL"
        fi
    fi
}

# Date is formatted like like this: "[Mon 01-01-00 00:00:00]"
dwm_date () {
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "📆 %s" "$(date "+%a %d-%m-%y %T")"
    else
        printf "DAT %s" "$(date "+%a %d-%m-%y %T")"
    fi
}


while true; do
  xsetroot -name " [$(cpu)] [$(dwm_resources)] [$(dwm_battery)]   [$(dwm_pulse)] [$(dwm_date)] "
 sleep 1m # upate time every minute
  # dwmblocks &
done &
