colorscheme desert

set nocompatible
set nu
set nobackup
set tabstop=4
set shiftwidth=4
set expandtab
set ignorecase
set smartcase
set incsearch
set hlsearch
set autoindent
set cindent
set wildmenu
set viminfo='100,f1
" set encoding=UTF-8
set background=dark
set foldcolumn=3
set laststatus=2

let g:netrw_browse_split=3
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" identifies gvim
if has("gui_running")
    winpos 840 0
    set lines=60
    set columns=110
else
    let g:indent_guides_auto_colors = 0
    hi IndentGuidesOdd ctermbg=lightgray
endif

call pathogen#infect('d:\work\var\vimfiles\bundle')
call pathogen#helptags()
