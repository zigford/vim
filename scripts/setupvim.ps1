#!/bin/bash

#deps
$VPlugURL = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
$VPlugP = "$Env:userprofile\vimfiles\autoload\plug.vim"
$ErrorActionPreference="SilentlyContinue"
if (!(get-command git)) { choco install git -y }
if (!(get-command vim)) { choco install vim -y }

# install vim-plug
if (!(Test-Path -Path $VPlugP)) {
    New-Item -ItemType Directory (Split-Path -Path $VPlugP -Parent) -Force
    Invoke-WebRequest -Uri $VPlugURL -OutFile $VPlugP
}

Copy-Item -Force ..\.vimrc ~\_vimrc
