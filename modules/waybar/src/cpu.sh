#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# CPU usage waybar component.
# Reports total usage; tooltip shows package temperature.
#-------------------------------------------------------------------------------

cpu_stat() {
    awk '/^cpu /{print $2+0,$3+0,$4+0,$5+0,$6+0,$7+0,$8+0,$9+0}' /proc/stat
}

read -ra s1 < <(cpu_stat)
sleep 0.25
read -ra s2 < <(cpu_stat)

idle1=$((s1[3] + s1[4]))
idle2=$((s2[3] + s2[4]))
total1=0; for v in "${s1[@]}"; do ((total1 += v)); done
total2=0; for v in "${s2[@]}"; do ((total2 += v)); done

dtotal=$((total2 - total1))
didle=$((idle2 - idle1))
usage=$(( dtotal > 0 ? 100 * (dtotal - didle) / dtotal : 0 ))

# Intel: coretemp "Package id 0". AMD: k10temp "Tctl".
temp=0
for hw in /sys/class/hwmon/hwmon*; do
    case $(<"$hw/name") in
        coretemp)
            for label in "$hw"/temp*_label; do
                [[ $(<"$label") == "Package id 0" ]] || continue
                temp=$(( $(<"${label%_label}_input") / 1000 ))
                break
            done
            break ;;
        k10temp)
            temp=$(( $(<"$hw/temp1_input") / 1000 ))
            break ;;
    esac
done

class=$( [ "$usage" -ge 90 ] && echo critical || ( [ "$usage" -ge 70 ] && echo heavy || ( [ "$usage" -ge 50 ] && echo medium || echo "" ) ) )
printf '{"text":"cpu %d%%","tooltip":"%d°C","percentage":%d,"class":"%s"}\n' "$usage" "$temp" "$usage" "$class"
