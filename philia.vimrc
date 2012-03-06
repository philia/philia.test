colorscheme desert

" identifies gvim
if has("gui")
    winpos 840 0
    set lines=60
    set columns=110
endif

set nu
set nobackup
set tabstop=4
set shiftwidth=4
set expandtab
set ignorecase
set smartcase
set incsearch
set autoindent
set cindent
set wildmenu
set viminfo='100,f1

let g:netrw_browse_split=3
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'

au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
