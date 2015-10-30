# composer global vendor binaries
if [ -d ~/.composer/vendor/bin ]; then
    PATH=$PATH:~/.composer/vendor/bin
fi

# direnv hook
if type direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi
