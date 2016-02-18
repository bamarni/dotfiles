alias php="php-bin php"
alias composer="php-bin composer"
alias phpspec="php-bin phpspec"
alias phpunit="php-bin phpunit"
alias puli="php-bin puli"
alias c="composer"

eval "$(docker run --rm -v ~/.composer:/root/.composer bamarni/php symfony-autocomplete --shell=zsh)"

# autocompletion for executables inside the docker container (shifts first word)
_php_bin() {
    shift words
    (( CURRENT-- ))

    [[ $words[1] != "php" ]] && _symfony && return

    _normal
}

compdef _php_bin php-bin
