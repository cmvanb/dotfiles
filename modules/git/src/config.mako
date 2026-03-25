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
    dark = true
    line-numbers = true
    line-numbers-left-format = "{nm:>2}⋮"
    line-numbers-right-format = "{np:>2}│"
    hunk-header-style = 'omit'
    syntax-theme = carbon-dark
    file-style = '"${color_hash('primary_11')}"'
    line-numbers-zero-style = '"${color_hash('primary_3')}"'
    minus-style = '"${color_hash('red_5')}" "${color_hash('red_0')}"'
    minus-emph-style = '"${color_hash('text_15')}" bold "${color_hash('red_3')}"'
    line-numbers-minus-style = '"${color_hash('red_3')}"'
    plus-style = 'syntax "${color_hash('green_0')}"'
    plus-emph-style = '"${color_hash('text_15')}" bold "${color_hash('green_3')}"'
    line-numbers-plus-style = '"${color_hash('green_3')}"'

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
