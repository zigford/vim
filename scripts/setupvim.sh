#!/bin/bash

# Function to get full path to a relative file. POSIX compliant. Ripped from:
# https://stackoverflow.com/a/3915420

function gfilepath(){
	echo "$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
}

#deps
which git || sudo apt-get install git -y

which curl || sudo apt-get install curl -y

which vim || sudo apt-get install vim -y

# install vim-plug
if ! test -f ~/.vim/autoload/plug.vim; then 
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

ln -s "$(gfilepath ../_vimrc)" ~/.vimrc
