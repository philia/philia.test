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
set background=dark
set foldcolumn=3
set laststatus=2

let g:netrw_browse_split=3
let g:netrw_sort_direction='reverse'
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'
let g:netrw_cygwin=0
let g:netrw_silent=1
let g:netrw_mousemaps=0

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

let g:Powerline_symbols = 'fancy'

au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

" identifies gvim
if has("gui_running")
    winpos 840 0
    set lines=60
    set columns=110
else
    let g:indent_guides_auto_colors = 1
    " hi IndentGuidesOdd ctermbg=lightgray
    " hi IndentGuidesEven ctermbg=darkgray
endif

call pathogen#helptags()

" fix issue about "unable to open swap file for [No Name], recover impossible
" also this prevent .swp file from generating to current directory of netrw
set dir=$TEMP

" Choose whether to enable or not
" set encoding=UTF-8

" local config
call pathogen#infect('d:\work\var\vimfiles\bundle')
let g:netrw_scp_cmd='d:\dev\utils\pscp.exe -i d:\dev\keys\private.ppk'
let g:netrw_list_cmd='d:\dev\utils\plink.exe USEPORT HOSTNAME -i d:\dev\keys\private.ppk ls -aF'

