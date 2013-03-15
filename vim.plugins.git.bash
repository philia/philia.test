#!/bin/bash
git clone git@github.com:tpope/vim-pathogen.git
git clone git@github.com:nathanaelkane/vim-indent-guides.git
git clone git@github.com:edsono/vim-matchit.git
git clone git@github.com:Lokaltog/vim-powerline.git
git clone git@github.com:Lokaltog/vim-easymotion.git
git clone git@github.com:thisivan/vim-taglist.git
git clone git@github.com:tpope/vim-surround.git
git clone git@github.com:kien/ctrlp.vim.git
#git clone git@github.com:sjbach/lusty.git
git clone git@github.com:Shougo/neosnippet.git
git clone git@github.com:Shougo/neocomplcache.git
git clone git@github.com:scrooloose/nerdtree.git
git clone git@github.com:godlygeek/tabular

wget http://s3.wincent.com/command-t/releases/command-t-1.4.vba

#install
#copy pathogen.vim to $VIMRUNTIME/autoload/
#git clone to $PATH_TO_VIMFILES/bundle/
#use the followed command to install vimball package:
# :e name.vba
# :!mkdir $PATH_TO_VIMFILES/bundle/name
# :UseVimball $PATH_TO_VIMFILES/bundle/name
