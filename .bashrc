# aliases
alias ll='ls -Al'

# machine specific
if [ -r ~/.bashrc_pre ]; then
   . ~/.bashrc_pre
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
