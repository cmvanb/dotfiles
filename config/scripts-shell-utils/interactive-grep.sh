#-------------------------------------------------------------------------------
# Fuzzy text search using ripgrep and fzf
#-------------------------------------------------------------------------------

RELOAD='reload:rg --column --color=always --smart-case {q} || :'
OPENER='nvim {1} +{2}'

# TODO: Use system theme colors.

fzf \
    --disabled \
    --ansi \
    --color 'border:#01244b,prompt:regular:#c1d1e1,current-bg:#023469,gutter:-1,pointer:#c1d1e1,info:#c1d1e1,spinner:#05aaff,label:#dfefff' \
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
    --preview 'bat --terminal-width 88 --wrap auto --style numbers --color always --highlight-line {2} {1}' \
    --preview-window 'right,+{2}/2,border-left,<80(down,border-top)' \
    --query "$*"
