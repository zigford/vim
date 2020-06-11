#!/bin/sh

# Function to get full path to a relative file. POSIX compliant. Ripped from:
# https://stackoverflow.com/a/3915420

gfilepath() {
	echo "$(cd "$(dirname "$0")"; pwd -P)/$(basename "$1")"
}

# install vim-plug
if ! test -f ~/.vim/autoload/plug.vim; then 
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -s "$(gfilepath ../_vimrc)" ~/.vimrc
