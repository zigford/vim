#!/bin/bash

#deps
which git || sudo apt-get install git -y

which curl || sudo apt-get install curl -y

which vim || sudo apt-get install vim -y

# install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# install auto-pairs
git clone git://github.com/jiangmiao/auto-pairs.git ~/.vim/bundle/auto-pairs

# install 

cat << EOF > ~/.vimrc
execute pathogen#infect()
syntax on
filetype plugin indent on
EOF
