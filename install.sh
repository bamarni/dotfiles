#!/usr/bin/env bash

git ls-files | rsync --files-from=- --exclude=install.sh . ~

. ~/.bash_profile
