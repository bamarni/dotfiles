#!/usr/bin/env sh

if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

git ls-files | rsync --files-from=- --exclude=install.sh . ~
