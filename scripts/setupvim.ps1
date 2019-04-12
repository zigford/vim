#!/bin/bash

#deps
$VPlugURL = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
$VPlugP = "$Env:userprofile\vimfiles\autoload\plug.vim"
$ErrorActionPreference="SilentlyContinue"
if (!(get-command git)) { choco install git -y }
if (!(get-command vim)) { choco install vim -y }
choco install firacode -y

# install vim-plug
if (!(Test-Path -Path $VPlugP)) {
    New-Item -ItemType Directory (Split-Path -Path $VPlugP -Parent) -Force
    Invoke-WebRequest -Uri $VPlugURL -OutFile $VPlugP
}

if (Test-Path ..\vimfiles) {
    If (-Not (Test-Path -Path ~\vimfiles)) {
        New-Item -ItemType Directory -Path $HOME -Name vimfiles
    }
    Copy-Item -Recurse ..\vimfiles\* ~\vimfiles -Force
}

Copy-Item -Force ..\_vimrc ~\_vimrc
