function __deploy_dotfiles_dir
    realpath (dirname (commandline -po)[1]) 2>/dev/null
end

function __deploy_modules
    set -l dir (__deploy_dotfiles_dir)
    test -n "$dir"
    and ls $dir/modules/ 2>/dev/null
end

function __deploy_profiles
    set -l dir (__deploy_dotfiles_dir)
    test -n "$dir"
    and ls $dir/profiles/ 2>/dev/null
end

function __deploy_no_subcommand
    not __fish_seen_subcommand_from install uninstall list show status
end

complete -c deploy.sh -f

complete -c deploy.sh -n __deploy_no_subcommand -a install   -d 'Install a profile or module'
complete -c deploy.sh -n __deploy_no_subcommand -a uninstall -d 'Uninstall profile or module'
complete -c deploy.sh -n __deploy_no_subcommand -a list      -d 'List available profiles and modules'
complete -c deploy.sh -n __deploy_no_subcommand -a show      -d 'Show resolved modules for a profile'
complete -c deploy.sh -n __deploy_no_subcommand -a status    -d 'Show currently deployed profile'

complete -c deploy.sh -n '__fish_seen_subcommand_from install' -a '(__deploy_modules)'  -d Module
complete -c deploy.sh -n '__fish_seen_subcommand_from install' -a '(__deploy_profiles)' -d Profile
complete -c deploy.sh -n '__fish_seen_subcommand_from install' -l dry-run -d 'Show what would be done'
complete -c deploy.sh -n '__fish_seen_subcommand_from install' -l host    -d 'Auto-detect profile from hostname'

complete -c deploy.sh -n '__fish_seen_subcommand_from uninstall' -a '(__deploy_modules)'  -d Module
complete -c deploy.sh -n '__fish_seen_subcommand_from uninstall' -a '(__deploy_profiles)' -d Profile

complete -c deploy.sh -n '__fish_seen_subcommand_from show' -a '(__deploy_profiles)' -d Profile
