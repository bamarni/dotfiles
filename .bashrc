# aliases
alias ll='ls -Al'

# machine specific
if [ -f ~/.bashrc_pre ]; then
   . ~/.bashrc_pre
fi

# mac osx autocomplete
if [[ "$OSTYPE" == "darwin"* ]] && type brew >/dev/null 2>&1; then
    brew_prefix=$(brew --prefix)
    if [ -f "$brew_prefix"/etc/bash_completion ]; then
        . "$brew_prefix"/etc/bash_completion
    fi
    unset brew_prefix
fi

# composer global vendor binaries
if [ -d ~/.composer/vendor/bin ]; then
    PATH=$PATH:~/.composer/vendor/bin
fi

# go
if [ -n "$GOPATH" ]; then
    PATH=$PATH:$GOPATH/bin
fi

# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi
