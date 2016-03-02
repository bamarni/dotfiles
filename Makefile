.PHONY: all omz sync completion

all: omz sync completion

omz:
	if [ ! -d ~/.oh-my-zsh ]; then \
		sh -c "$$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"; \
	fi

sync:
	git ls-files | rsync --files-from=- --exclude=Makefile . ~

completion:
	mkdir -p ~/.zsh_completion
	for php_bin in composer phpspec; do \
		docker run --rm -v ~/.composer:/root/.composer bamarni/php \
			symfony-autocomplete $$php_bin --shell=zsh > ~/.zsh_completion/_$$php_bin; \
	done

default: sync
