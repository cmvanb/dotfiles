<%
palette_entries = []
idx = 16
for name, count in [
    ('primary', 16), ('secondary', 16), ('text', 16), ('gray', 16),
    ('red', 10), ('orange', 10), ('yellow', 10), ('green', 10),
    ('cyan', 10), ('blue', 10), ('purple', 10), ('magenta', 10),
]:
    for i in range(count):
        palette_entries.append((idx, f'{name}_{i}'))
        idx += 1
%>
background = ${color_hash('terminal_bg')}
foreground = ${color_hash('terminal_text')}

palette = 0=${color_hash('ansi_black')}
palette = 1=${color_hash('ansi_red')}
palette = 2=${color_hash('ansi_green')}
palette = 3=${color_hash('ansi_yellow')}
palette = 4=${color_hash('ansi_blue')}
palette = 5=${color_hash('ansi_magenta')}
palette = 6=${color_hash('ansi_cyan')}
palette = 7=${color_hash('ansi_white')}
palette = 8=${color_hash('ansi_brblack')}
palette = 9=${color_hash('ansi_brred')}
palette = 10=${color_hash('ansi_brgreen')}
palette = 11=${color_hash('ansi_bryellow')}
palette = 12=${color_hash('ansi_brblue')}
palette = 13=${color_hash('ansi_brmagenta')}
palette = 14=${color_hash('ansi_brcyan')}
palette = 15=${color_hash('ansi_brwhite')}
% for index, key in palette_entries:
palette = ${index}=${color_hash(key)}
% endfor

cursor-color = ${color_hash('terminal_text')}

selection-background = ${color_hash('selection_bg')}
selection-foreground = ${color_hash('selection_fg')}
