export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

plugins=(git docker docker-machine docker-compose composer)

source $ZSH/oh-my-zsh.sh

# go
if type go >/dev/null 2>&1; then
    export GOPATH=$HOME/go
    PATH=$PATH:$GOPATH/bin
fi

# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook zsh)"
fi
