#!/bin/bash
# Compile vim with python
./configure --prefix=/home/httpd/work/opt/ --enable-pythoninterp --with-python-config-dir=/home/httpd/work/opt/lib/python2.7/config --with-features=huge

# Plugins Section
# GIT version
#git clone git@github.com:tpope/vim-pathogen.git
#git clone git@github.com:tpope/vim-surround.git
#git clone git@github.com:nathanaelkane/vim-indent-guides.git
#git clone git@github.com:edsono/vim-matchit.git
#git clone git@github.com:Lokaltog/vim-powerline.git
#git clone git@github.com:Lokaltog/vim-easymotion.git
#git clone git@github.com:thisivan/vim-taglist.git
#git clone git@github.com:kien/ctrlp.vim.git
#git clone git@github.com:scrooloose/nerdtree.git
#git clone git@github.com:godlygeek/tabular.git
#git clone git@github.com:Valloric/YouCompleteMe.git

#install
#copy pathogen.vim to $VIMRUNTIME/autoload/
#git clone to $PATH_TO_VIMFILES/bundle/
#use the followed command to install vimball package:
# :e name.vba
# :!mkdir $PATH_TO_VIMFILES/bundle/name
# :UseVimball $PATH_TO_VIMFILES/bundle/name

# HTTPS version
git clone https://github.com/tpope/vim-pathogen.git
git clone https://github.com/tpope/vim-surround.git
git clone https://github.com/nathanaelkane/vim-indent-guides.git
git clone https://github.com/edsono/vim-matchit.git
git clone https://github.com/Lokaltog/vim-powerline.git
git clone https://github.com/Lokaltog/vim-easymotion.git
git clone https://github.com/thisivan/vim-taglist.git
git clone https://github.com/kien/ctrlp.vim.git
git clone https://github.com/scrooloose/nerdtree.git
git clone https://github.com/godlygeek/tabular.git
git clone https://github.com/Valloric/YouCompleteMe.git
