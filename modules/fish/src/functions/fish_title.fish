#-------------------------------------------------------------------------------
# Fish terminal title configuration
#-------------------------------------------------------------------------------

function fish_title --description 'Print the title'
    set -q argv[1]; or set argv fish

    echo $argv (fish_prompt_pwd_dir_length=0 prompt_pwd)
end
