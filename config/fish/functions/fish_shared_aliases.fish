#-------------------------------------------------------------------------------
# Fish aliases
#-------------------------------------------------------------------------------

function fish_shared_aliases

    # Git
    abbr -a ga git add
    abbr -a gaa git add -A
    abbr -a gai git add -i
    abbr -a gb git branch -v
    abbr -a gc git commit -m
    abbr -a gca git commit --amend
    abbr -a gco git checkout
    abbr -a gcp git cherry-pick
    abbr -a gd git diff
    abbr -a gds git diff --staged
    abbr -a gl git log --pretty=history
    abbr -a gp git push
    abbr -a gpf git push --force
    abbr -a gpu git pull --rebase
    abbr -a gr git remote -v
    abbr -a grb git rebase -i
    abbr -a grc git rm --cached
    abbr -a grs git reset HEAD
    abbr -a grt git restore
    abbr -a gs git status
    abbr -a gsh git show
    abbr -a gsu git status -u
    abbr -a gss git switch
    abbr -a gsc git switch -c

    # General
    alias bat "bat --force-colorization --no-paging --style=grid,numbers"
    abbr -a c clear
    abbr -a e edit
    abbr -a ed edit
    abbr -a edi edit
    alias eza "eza -l --color=always --group-directories-first --time-style=long-iso"
    abbr -a ez eza
    abbr -a ex eza
    abbr -a exa eza
    abbr -a lf lfcd
    abbr -a ls eza
    abbr -a lsa eza -a
    abbr -a lsd eza -a
    abbr -a lsi eza --git-ignore
    abbr -a lst eza -T --git-ignore
    abbr -a lsta eza -aT --git-ignore
    abbr -a ip ip -c
    abbr -a rga rg --hidden --no-ignore

    # Python
    abbr -a vv generate-venv.sh
    abbr -a va source venv/bin/activate.fish
    abbr -a vd deactivate

    # Docker
    abbr -a d docker
    abbr -a dc "docker compose"
    abbr -a dps "docker ps | view"
end
