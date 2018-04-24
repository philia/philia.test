" {{{ Global configuration
    syntax on

    if has("autocmd")
        filetype plugin indent on
    endif

    set nocompatible
    set guifont=Consolas
    " set number
    set relativenumber
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
    set tabstop=4
    set shiftwidth=4
    set expandtab
    " enable the feature to put modified buffer in background
    set hidden
    " set default foldmethod to marker {{{,}}}
    set foldmethod=marker

    let mapleader = ","

    if exists("+autochdir")
        set autochdir
    endif

    set guitablabel="%r%m%t"

    " fix issue about backspace doesn't work in insert mode
    set backspace=2

    " disable preview window (annoying 'Scratch')
    set completeopt-=preview
    set encoding=UTF-8
    " for linux to display colors for powerline, this also affect indent-guides under msys
    set t_ut=
    set t_Co=256
" }}}
" {{{ Identifies gvim
if has("win32") && has("gui_running")
    winpos 840 0
    set lines=62
    set columns=110
    " maximize the window
    au GUIEnter * simalt ~X
    " hide menu bar
    set guioptions -=m
    " hide toolbar
    set guioptions -=T
    " hide right scrollbar
    set guioptions -=r

    let g:pathogen_disabled = []
    call add(g:pathogen_disabled, 'DBGPavim')
else
endif
" }}}
" {{{ Key bindings
    inoremap jk <esc>
    inoremap kj <esc>
    ""   make < > shifts keep selection
    "vnoremap < <gv
    "vnoremap > >gv
    " Tab management
    " \e to open a new tab as the first one
    silent! nnoremap <unique> <silent> <Leader>e :0tabnew<CR>

    " Commands
    " \n to call :noh
    silent! nnoremap <unique> <silent> <Leader>n :noh<CR>

    " Plugins
    " \N to open :NerdTree
    silent! nnoremap <unique> <silent> <Leader>N :NERDTree<CR>
    " \cpb to open CtrlP using buffer
    silent! nnoremap <unique> <silent> <Leader>cpb :CtrlPBuffer<CR>
    " \cpm to open CtrlP using MRU file mode
    silent! nnoremap <unique> <silent> <Leader>cpm :CtrlPMixed<CR>
    " \cpc to open customized path
    silent! nnoremap <unique> <Leader>cpc :CtrlP<Space>
    " \fdi to set fold method to indent
    silent! nnoremap <unique> <Leader>fdi :set foldmethod=indent<CR>
    " \fdm to set fold method to manual
    silent! nnoremap <unique> <Leader>fdm :set foldmethod=manual<CR>
" }}}
" {{{ Plugins configurations
let g:ctrlp_clear_cache_on_exit = 0
let g:solarized_termcolors=256
let NERDTreeDirArrows = 1
" let NERDTreeQuitOnOpen = 1
" Configure relativenumber for NerdTree:
" bundle/nerdtree/ftplugin/nerdtree.vim: setlocal relativenumber (with this line and this line only)
" vim-airline to display full path of current file
let g:airline_section_c='%<%F%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#'
"}}}
" {{{ cscope
if has('cscope')
    set cscopetag cscopeverbose
    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif
    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    "cnoreabbrev css cs show
    cnoreabbrev csh cs help
endif
" {{{ autoloading for cscope
function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose " suppress 'duplicate connection' error
        " exe "cs add " . db . " " . path . " -C"
        exe "cs add " . db . " " . path
        set cscopeverbose
    endif
endfunction
" }}}
" }}}
" {{{ Random color scheme
com! DCS exec ':colorscheme desert'
com! RCS exec 'let randcolor=[
            \"solarized",
            \"desert256",
            \"molokai", 
            \"rdark-terminal",
            \"jellybeans",
            \"mint",
            \"navajo-night",
            \"wombat"
            \] | exe "colo " . randcolor[localtime() % len(randcolor)] | unlet randcolor'
com! RRCS exec 'let mycolors=split(globpath(&rtp,"**/colors/*.vim"),"\n") | exe "so " . mycolors[localtime() % len(mycolors)] | unlet mycolors'
" }}}
" {{{ Startup commands
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview
"autocmd BufEnter * call LoadCscope()
"autocmd VimEnter * call LoadCscope()
" }}}
""" {{{ TODO: local config
""" make sure this line is added as the first line before source this vimrc
""" Config Zone start
""let g:phrepopath='/Users/philia/Documents/repo/philia.test'
""let g:tempdir='/Users/philia/Documents/tmp'
""" Config Zone end, DO NOT MODIFY ANYTHING BELOW!!
""
""" Uncomment these lines to enable plugins and customized config
""if !isdirectory(g:tempdir.'/vim.view')
""    call mkdir(g:tempdir.'/vim.view')
""endif
""if !isdirectory(g:tempdir.'/vim.tmp')
""    call mkdir(g:tempdir.'/vim.tmp')
""endif
""
""" Vundle default configurations
""set nocompatible              " be iMproved, required
""filetype off                  " required
""
""" set the runtime path to include Vundle and initialize
""set shell=/bin/sh
""" set rtp+=~/mnt/philia.test/vimfiles/Vundle.vim
""execute 'set rtp+='.g:phrepopath.'/vimfiles/Vundle.vim'
""call vundle#begin()
""" alternatively, pass a path where Vundle should install plugins
"""call vundle#begin('~/some/path/here')
""
""" let Vundle manage Vundle, required
""Plugin 'VundleVim/Vundle.vim'
""
""" The following are examples of different formats supported.
""" Keep Plugin commands between vundle#begin/end.
""" plugin on GitHub repo
""Plugin 'tpope/vim-fugitive'
""Plugin 'tpope/vim-surround'
""Plugin 'bumaociyuan/vim-matchit'
""Plugin 'Lokaltog/vim-easymotion'
""Plugin 'kien/ctrlp.vim'
""Plugin 'scrooloose/nerdtree'
""Plugin 'bling/vim-airline'
""Plugin 'flazz/vim-colorschemes'
""Plugin 'airblade/vim-gitgutter'
""Plugin 'luochen1990/rainbow'
""Plugin 'godlygeek/tabular'
""
"""" plugin from http://vim-scripts.org/vim/scripts.html
"""Plugin 'L9'
"""" Git plugin not hosted on GitHub
"""Plugin 'git://git.wincent.com/command-t.git'
"""" git repos on your local machine (i.e. when working on your own plugin)
"""Plugin 'file:///home/gmarik/path/to/plugin'
"""" The sparkup vim script is in a subdirectory of this repo called vim.
"""" Pass the path to set the runtimepath properly.
"""Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
"""" Avoid a name conflict with L9
"""Plugin 'user/L9', {'name': 'newL9'}
""
""" All of your Plugins must be added before the following line
""call vundle#end()            " required
""filetype plugin indent on    " required
""" To ignore plugin indent changes, instead use:
"""filetype plugin on
""
""" Brief help
""" :PluginList       - lists configured plugins
""" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
""" :PluginSearch foo - searches for foo; append `!` to refresh local cache
""" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"""
""" see :h vundle for more details or wiki for FAQ
""" Put your non-Plugin stuff after this line
""
""""if has("gui_running")
""""    set transparency=10
""""endif
""""
""execute "source ".g:phrepopath."/vimrc"
""""" DCS " Random select a default color scheme (in randcolor list)
""colo molokai
""" }}}
