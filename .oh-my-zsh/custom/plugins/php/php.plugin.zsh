alias phpunit="php-bin phpunit"
alias puli="php-bin puli"
alias c="composer"

# todo : switch to static completion functions
_symfony()
{
    local state com cur commands options

    cur=${words[${#words[@]}]}

    # lookup for command
    for word in ${words[@]:1}; do
        if [[ $word != -* ]]; then
            com=$word
            break
        fi
    done

    [[ ${cur} == --* ]] && state="option"

    [[ $cur == $com ]] && state="command"

    case $state in
        command)
            commands=("${(@f)$(docker run --rm -v ~/.composer:/root/.composer bamarni/php ${words[1]} list --no-ansi --raw 2>/dev/null | awk '{ gsub(/:/, "\\:", $1); print }' | awk '{if (NF>1) print $1 ":" substr($0, index($0,$2)); else print $1}')}")
            _describe 'command' commands
        ;;
        option)
            options=("${(@f)$(docker run --rm -v ~/.composer:/root/.composer bamarni/php ${words[1]} -h ${words[2]} --no-ansi 2>/dev/null | sed -n '/Options/,/^$/p' | sed -e '1d;$d' | sed 's/[^--]*\(--.*\)/\1/' | sed -En 's/[^ ]*(-(-[[:alnum:]]+){1,})[[:space:]]+(.*)/\1:\3/p' | awk '{$1=$1};1')}")
            _describe 'option' options
        ;;
        *)
            # fallback to file completion
            _arguments '*:file:_files'
    esac
}

compdef _symfony console
compdef _symfony composer
compdef _symfony php-cs-fixer
compdef _symfony phpspec
compdef _symfony behat
