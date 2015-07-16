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
    " winpos 840 0
    " set lines=62
    " set columns=110
    " maximize the window
    " au GUIEnter * simalt ~X
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
" {{{ Configure relativenumber for NerdTree:
" bundle/nerdtree/ftplugin/nerdtree.vim: setlocal relativenumber (with this line and this line only)
" }}}
" {{{ Key bindings
    inoremap jk <esc>
    inoremap kj <esc>
    "   make < > shifts keep selection
    vnoremap < <gv
    vnoremap > >gv
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
"let NERDTreeQuitOnOpen = 1
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
autocmd BufEnter * call LoadCscope()
autocmd VimEnter * call LoadCscope()
" }}}
" {{{ TODO: local config
" make sure this line is added as the first line before source this vimrc
" let g:phrepopath='~/dev/var/github/philia.test'
" let g:tempdir='/tmp'

""" Uncomment these lines to enable plugins and customized config
" if !isdirectory(g:tempdir.'/vim.view')
"     call mkdir(g:tempdir.'/vim.view')
" endif
" if !isdirectory(g:tempdir.'/vim.tmp')
"     call mkdir(g:tempdir.'/vim.tmp')
" endif
" execute 'source '.g:phrepopath.'/vimfiles/bundle/vim-pathogen/autoload/pathogen.vim'
" execute 'source '.g:phrepopath.'/vimrc'
" execute 'set viewdir='.g:tempdir.'/vim.view'
" execute 'set dir='.g:tempdir.'/vim.tmp'

" call pathogen#infect(g:phrepopath.'/vimfiles/bundle/{}')
" call pathogen#helptags()

" RCS " Random select a default color scheme (in randcolor list)
" }}}
