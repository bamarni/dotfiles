#!/usr/bin/env sh

if [ ! -d ~/.oh-my-zsh ]; then
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

git ls-files | rsync --files-from=- --exclude=install.sh . ~

mkdir -p ~/.zsh_completion
for php_bin in composer phpspec; do
    echo "#compdef $php_bin" | (cat && docker run --rm -v ~/.composer:/root/.composer bamarni/php \
	    symfony-autocomplete $php_bin --shell=zsh) > ~/.zsh_completion/_$php_bin
done
