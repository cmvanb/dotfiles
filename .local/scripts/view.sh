#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# View a text file in the pager, then print it to terminal on exit.
#-------------------------------------------------------------------------------

set -euo pipefail

script_name=$(basename "$0")

print=false

# Print the usage instructions.
usage() {
    echo "$script_name [--print] FILENAME" >&2
    echo "" >&2
    echo "Pretty prints the inputs and passes it to a pager. Accepts either FILENAME or" >&2
    echo "standard input." >&2
    echo "" >&2
    echo "Options:" >&2
    echo "--print: Optionally print the input to the terminal after paging." >&2
}

# Parse command line options.
while getopts ":-:" option; do
    [[ "${option}" == "-" ]] || continue
    case "${OPTARG}" in
        print)
            print=true
            ;;
        help)
            usage
            exit 1
            ;;
        *)
            echo "Invalid parameter \`$OPTARG\`." >&2
            echo "" >&2
            usage
            exit 1
            ;;
    esac
done

if [[ -t 0 ]]; then
    bat --force-colorization --paging=never --style=numbers --wrap=never "$1" | less -c -R -S

    if [[ "$print" == true ]]; then
        bat --force-colorization --paging=never --style=numbers --wrap=never "$1"
    fi
else
    # Read from stdin.
    input=$(cat -)

    bat --paging=never --style=plain --wrap=never <(echo "$input") | less -c -R -S

    if [[ "$print" == true ]]; then
        bat --force-colorization --paging=never --style=plain --wrap=never <(echo "$input")
    fi
fi
