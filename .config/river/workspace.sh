pkill -x yambar

outputs=$(wlr-randr | grep "^[^ ]" | awk '{ print$1 }')
total=$(wlr-randr | grep "^[^ ]" | awk '{ print$1 }' | wc -l)
primary="DP-3"

for o in ${outputs}; do
	riverctl focus-output ${o}
	yambar &
	sleep 0.2
done

if [ "$total" -gt "1" ]; then
	riverctl focus-output $primary
fi

exit 0
