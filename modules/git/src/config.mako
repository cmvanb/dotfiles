[user]
    email = casper@codemu.ch
    name = Casper

[core]
    autocrlf = false
    eol = lf
    editor = nvim
    pager = delta

[init]
    defaultBranch = main

[interactive]
    diffFilter = delta --color-only

[delta]
    paging = always
    pager = less
    ${scheme_variant} = true
    line-numbers = true
    line-numbers-left-format = "{nm:>2}⋮"
    line-numbers-right-format = "{np:>2}│"
    hunk-header-style = 'omit'
    syntax-theme = carbon
    features = carbon

# Options in [delta] override features, so styles live in features.
[delta "carbon"]
    file-style = '"${color_hash('primary_11')}"'
    line-numbers-zero-style = '"${color_hash('primary_8')}"'
    minus-style = '"${color_hash('red_5')}" "${color_hash('red_0')}"'
    minus-emph-style = '"${color_hash('text_15')}" bold "${color_hash('red_3')}"'
    line-numbers-minus-style = '"${color_hash('red_4')}"'
    plus-style = 'syntax "${color_hash('green_0')}"'
    plus-emph-style = '"${color_hash('text_15')}" bold "${color_hash('green_3')}"'
    line-numbers-plus-style = '"${color_hash('green_4')}"'

# Linux console: 8 background colors, activated via DELTA_FEATURES.
[delta "vt"]
    file-style = 'syntax blue'
    line-numbers-zero-style = 'brightblue'
    minus-style = 'syntax red'
    minus-emph-style = 'brightred red'
    line-numbers-minus-style = 'brightred'
    plus-style = 'syntax green'
    plus-emph-style = 'brightgreen green'
    line-numbers-plus-style = 'brightgreen'

[filter "lfs"]
    clean = git-lfs clean -- %f
    smudge = git-lfs smudge -- %f
    process = git-lfs filter-process
    required = true

[log]
    abbrevCommit = true
    date = format:%Y-%m-%d %H:%M

[pretty]
    history = %C(yellow)[%h]%C(reset) %<(16,trunc)%ad %C(cyan)%an%C(reset) %C(green)%s%C(reset)

[color]
    ui = always

[pager]
    branch = false

[alias]
    cmvanb = "config user.email 'casper@codemu.ch'"
