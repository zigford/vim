#!/bin/bash

#deps
which git || sudo apt-get install git -y

which curl || sudo apt-get install curl -y

which vim || sudo apt-get install vim -y

# install vim-plug
if ! test -f ~/.vim/autoload/plug.vim; then 
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

cp -f ../.vimrc ~/.vimrc
