# Adds display labels to `sysupdate status --json`: each pacnew path becomes
# {path, label}, where the label fits $max characters.

# Cut characters from the middle of a string.
def ellipsize($max):
    if length <= $max then .
    else .[0:($max - 1) / 2 | floor] + "…" + .[length - (($max - 1) / 2 | ceil):]
    end;

# Replace the fewest middle directories with "…", keeping the top directory
# and the file name. Paths that still do not fit lose middle characters.
def shorten($max):
    if length <= $max then .
    else
        split("/") as $parts
        | [range(2; ($parts | length) - 1)] as $middle
        | first(
            (range(1; ($middle | length) + 1) as $count
             | $middle[(($middle | length) - $count) / 2 | floor] as $from
             | $parts[0:$from] + ["…"] + $parts[$from + $count:]
             | join("/")
             | select(length <= $max)),
            (if ($middle | length) > 0 then $parts[0:2] + ["…", $parts[-1]] | join("/") else . end
             | ellipsize($max)))
    end;

.pacnew_files |= map({path: ., label: shorten($max)})
