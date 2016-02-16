[[ -t 0 ]] && stty -echo
echo -n '\r\e[K'

export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git golang docker docker-machine docker-compose)

source $ZSH/oh-my-zsh.sh

# executables
export PATH=$HOME/bin:$PATH


# docker
docker-clean() {
    if [[ "$1" == "-f" ]]; then
        ids=$(docker ps -q)
        if [[ -n "$ids" ]]; then
            echo "Stopping running containers..."
            docker stop ${(f)ids}
        fi
    fi
    ids=$(docker ps -aq -f status=created)
    ids+=$(docker ps -aq -f status=exited)
    [[ -z "$ids" ]] && return
    echo "Removing inactive containers..."
    docker rm ${(f)ids}
}


# go
if type go >/dev/null 2>&1; then
    export GOPATH=$HOME/go
    PATH=$GOPATH/bin:$PATH
fi


# php
alias php="php-bin php"
alias composer="php-bin composer"
alias phpspec="php-bin phpspec"
alias phpunit="php-bin phpunit"
alias c="composer"

export PATH=$HOME/.composer/vendor/bin:$PATH

eval "$(docker run --rm -v ~/.composer:/root/.composer bamarni/php symfony-autocomplete --shell=zsh)"

# autocompletion for executables inside the php docker container (shifts first word)
_php_bin() { shift words; (( CURRENT-- )); _symfony && return; }; compdef _php_bin php-bin;

# ansible
alias ansible-playbook=ansible-playbook-debugger

# for long running playbooks : "ansible-playbook ...; saydone"
saydone() {
    voices=("Good News" Whisper Hysterical Princess Bells "Bad News" Bahh)
    words=(done maybe no failure "oh my god" finished yes success "you broke it")

    say -v "${voices[RANDOM % ${#voices[@]} + 1]}" "${words[RANDOM % ${#words[@]} + 1]}"
}


# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
