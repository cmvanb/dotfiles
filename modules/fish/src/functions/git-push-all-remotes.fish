function git-push-all-remotes
    set remotes (git remote)
    if test (count $remotes) -eq 0
        echo "git push"
        return
    end
    set cmds
    for r in $remotes
        set --append cmds "git push $r"
    end
    string join " && " $cmds
end
