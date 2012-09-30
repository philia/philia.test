colorscheme desert
set guifont=Consolas

set nocompatible
set nu
set nobackup
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
if exists("+autochdir")
    set autochdir
endif

set tabstop=4
set shiftwidth=4
set expandtab

set fillchars+=stl:\ ,stlnc:\
" show invisible chars like TAB
" set list
" set nolist

let g:netrw_browse_split=3
let g:netrw_sort_direction='reverse'
let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'
let g:netrw_cygwin=0
let g:netrw_silent=1
let g:netrw_mousemaps=0
let g:netrw_keepdir=0
" let g:netrw_liststyle=3

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

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

" let g:Powerline_symbols = 'fancy'
" let g:Powerline_cache_enabled = 0
let g:Powerline_symbols = 'compatible'
let g:Powerline_dividers_override = ['>>', '>', '<<', '<']

au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
" automatically opens netrw browser
" autocmd VimEnter * Ex
" this will help if 'set autochdir' doesn't work sometimes
" autocmd BufEnter * silent! lcd %:p:h


" TODO: local config
" Choose whether to enable or not
" set encoding=UTF-8
" for linux to display colors for powerline
" set t_Co=256

" fix issue about "unable to open swap file for [No Name], recover impossible also this prevent .swp file from generating to current directory of netrw for Windows
" set dir=$TEMP for windows or set dir=/tmp for Linux

" cd d:\work
" call pathogen#infect('d:\work\var\vimfiles\bundle')
" call pathogen#helptags()
" where bookmarks and history are saved (as .netrwbook and .netrwhist), must be configured because of bugs of netrw, it saves .netrwbook and .netrwhist to the first folder in bundle
" let g:netrw_home='d:\dev\tmp'
" let g:netrw_scp_cmd='d:\dev\utils\pscp.exe -i d:\dev\keys\private.ppk'
" let g:netrw_list_cmd='d:\dev\utils\plink.exe USEPORT HOSTNAME -i d:\dev\keys\private.ppk ls -aF'
