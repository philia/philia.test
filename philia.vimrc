colorscheme desert

" identifies gvim
if has("gui")
    winpos 840 0
    set lines=60
    set columns=110
endif

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
set background=dark

let g:netrw_browse_split=3
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
