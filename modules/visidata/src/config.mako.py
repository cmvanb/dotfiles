<%
# Carbon Dark theme for VisiData
# Colors specified as: <index> <fallback-name>
# All indices are 256-color palette indices mapped from carbon-dark.yaml
# via color_256('palette_name').
#
# Design notes:
#   - Backgrounds use the primary/gray cool-blue darks
#   - Foregrounds use text palette warm creams
#   - Accents: cyan=identifiers/keys, orange=selected, yellow=notes/warnings,
#              green=add/ok, red=delete/error, magenta=special/misc
%>
import subprocess

Sheet.addCommand('gx', 'open-cell-url', 'subprocess.Popen(["xdg-open", cursorDisplay])', 'open current cell value as URL with xdg-open')

vd.themes['carbon-dark'] = dict(
    # Base
    # terminal bg (primary_0) + warm text (text_11)
    color_default          = '${color_256("text_11")} on ${color_256("primary_0")}',
    color_default_hdr      = 'bold ${color_256("text_15")} on ${color_256("primary_0")}',
    color_bottom_hdr       = 'underline ${color_256("text_15")} on ${color_256("primary_0")}',
    color_column_sep       = '${color_256("gray_5")} on ${color_256("primary_0")}',

    # Cursor
    # Row: primary_6 bg, bright text
    color_current_row      = '${color_256("text_15")} on ${color_256("primary_6")}',
    # Col: primary_4 bg (slightly darker than row)
    color_current_col      = 'bold on ${color_256("primary_4")}',
    color_current_hdr      = 'bold reverse',
    color_current_cell     = 'bold ${color_256("text_15")} on ${color_256("primary_8")}',

    # Key columns (cyan — same role as identifiers in syntax theme)
    color_key_col          = 'bold ${color_256("cyan_6")}',

    # Hidden columns
    color_hidden_col       = '${color_256("gray_8")}',

    # Selected rows (orange — same as ansi_yellow / warning accent)
    color_selected_row     = '${color_256("orange_6")}',

    # Edit
    color_edit_cell        = '${color_256("text_15")} on ${color_256("primary_9")}',
    color_edit_unfocused   = '${color_256("text_8")} on ${color_256("primary_5")}',

    # Notes
    color_note_row         = '${color_256("yellow_5")}',   # row-level note flag
    color_note_type        = '${color_256("yellow_6")}',   # non-str type note
    color_note_pending     = 'bold ${color_256("green_5")}',

    # Pending mutations (matching btop/sway: green=add, yellow=change, red=delete)
    color_add_pending      = '${color_256("green_5")}',
    color_change_pending   = 'reverse ${color_256("yellow_5")}',
    color_delete_pending   = '${color_256("red_5")}',

    # Status bars
    # Active: primary_8 bg (mid-blue)
    color_status           = 'bold on ${color_256("primary_8")}',
    color_top_status       = 'underline',
    color_active_status    = '${color_256("text_15")} on ${color_256("primary_8")}',
    color_inactive_status  = '${color_256("gray_10")} on ${color_256("gray_4")}',
    color_highlight_status = '${color_256("primary_0")} on ${color_256("green_4")}',
    color_keystrokes       = 'bold ${color_256("text_15")} on ${color_256("gray_6")}',
    color_longname_status  = '${color_256("text_11")}',
    color_status_replay    = '${color_256("green_5")}',
    color_working          = '${color_256("green_5")}',

    # Errors / warnings (red, orange — same as btop temp gradients)
    color_error            = 'bold ${color_256("red_6")}',
    color_warning          = '${color_256("orange_6")}',

    # Search match (primary_12 bg — selection_bg equivalent)
    color_match            = 'bold ${color_256("primary_15")}',

    # Menu (primary_8 bg to match status bar)
    color_menu             = '${color_256("text_13")} on ${color_256("primary_8")}',
    color_menu_active      = 'bold ${color_256("text_15")} on ${color_256("primary_12")}',
    color_menu_help        = 'italic ${color_256("text_10")} on ${color_256("primary_8")}',
    color_menu_spec        = '${color_256("text_15")} on ${color_256("green_4")}',

    # Heading (inside help/guide sheets)
    color_heading          = 'bold ${color_256("text_15")} on ${color_256("primary_9")}',

    # Help/guide sheets
    color_code             = 'bold ${color_256("cyan_6")} on ${color_256("gray_5")}',
    color_keys             = 'bold reverse',
    color_guide_unwritten  = '${color_256("gray_10")}',
    color_longname_guide   = '${color_256("gray_10")}',

    # Sidebar
    color_sidebar          = '${color_256("text_11")} on ${color_256("primary_5")}',
    color_sidebar_title    = '${color_256("primary_0")} on ${color_256("cyan_5")}',

    # Command palette
    color_cmdpalette       = '${color_256("text_15")} on ${color_256("primary_6")}',

    # Aggregator summary row
    color_aggregator       = 'bold ${color_256("text_15")} on ${color_256("gray_5")}',

    # Currency
    color_currency_neg     = '${color_256("red_6")}',

    # Graphs
    color_graph_axis       = 'bold ${color_256("text_11")}',
    color_graph_hidden     = '${color_256("gray_8")}',
    color_graph_refline    = '${color_256("primary_10")}',
    color_graph_selected   = 'bold ${color_256("orange_6")}',

    # Diff
    color_diff             = '${color_256("yellow_5")}',
    color_diff_add         = '${color_256("green_5")}',

    # Clickable
    color_clickable        = 'underline ${color_256("primary_15")}',

    # Plot point colors (space-separated list of color specs used for multi-series graphs)
    # cyan, orange, green, purple, yellow, red, blue, magenta
    plot_colors            = '${color_256("cyan_6")} ${color_256("orange_6")} ${color_256("green_5")} ${color_256("purple_6")} ${color_256("yellow_5")} ${color_256("red_6")} ${color_256("blue_7")} ${color_256("magenta_6")}',
)

options.theme = 'carbon-dark'
