#!/bin/bash
git clone git@github.com:tpope/vim-pathogen
git clone git@github.com:nathanaelkane/vim-indent-guides
git clone git@github.com:edsono/vim-matchit
git clone git@github.com:Lokaltog/vim-powerline

#install
#copy pathogen.vim to $VIMRUNTIME/autoload/
#git clone to $PATH_TO_VIMFILES/bundle/
#use the followed command to install vimball package:
# :e name.vba
# :!mkdir $PATH_TO_VIMFILES/bundle/name
# :UseVimball $PATH_TO_VIMFILES/bundle/name
