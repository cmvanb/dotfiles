#-------------------------------------------------------------------------------
# Fuzzy text search using ripgrep and fzf
#-------------------------------------------------------------------------------

RELOAD='reload:rg --column --color=always --smart-case {q} || :'
OPENER='nvim {1} +{2}'

source "$XDG_OPT_HOME/theme/theme.sh"

fzf \
    --disabled \
    --ansi \
    --color "border:$(color_hash "${text_6:?}")" \
    --color "prompt:regular:$(color_hash "${text_13:?}")" \
    --color "current-bg:$(color_hash "${primary_4:?}"),gutter:-1" \
    --color "info:$(color_hash "${text_13:?}")" \
    --color "spinner:$(color_hash "${text_13:?}")" \
    --color "label:$(color_hash "${text_15:?}")" \
    --color "marker:$(color_hash "${debug:?}")" \
    --bind "start:$RELOAD" \
    --bind "change:$RELOAD" \
    --bind "enter:become:$OPENER" \
    --bind "ctrl-o:execute:$OPENER" \
    --delimiter : \
    --tabstop 4 \
    --layout reverse \
    --border none \
    --info right \
    --info-command 'echo -e "$FZF_POS/$FZF_MATCH_COUNT"' \
    --no-scrollbar \
    --prompt 'rg ❱ ' \
    --pointer '' \
    --highlight-line \
    --margin 0 \
    --padding 0 \
    --scroll-off 4 \
    --preview 'bat --terminal-width 128 --wrap auto --style numbers --color always --highlight-line {2} {1}' \
    --preview-window 'right,+{2}/2,border-left,<80(down,border-top)' \
    --query "$*"
