" Global configuration
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
set t_Co=256

if has('cscope')
    set cscopetag cscopeverbose
    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif
    cnoreabbrev csa cs add
    cnoreabbrev csf cs find
    cnoreabbrev csk cs kill
    cnoreabbrev csr cs reset
    cnoreabbrev css cs show
    cnoreabbrev csh cs help
endif

" Variables
let NERDTreeDirArrows = 1
let NERDTreeQuitOnOpen = 1
" Configure relativenumber for NerdTree:
" bundle/nerdtree/ftplugin/nerdtree.vim: setlocal relativenumber (with this line and this line only)

" identifies gvim
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

let g:ctrlp_clear_cache_on_exit = 0

" Key bindings
" Tab management
" \e to open a new tab as the first one
silent! nnoremap <unique> <silent> <Leader>e :0tabnew<CR>
" \o to close all tabs except the current
silent! nnoremap <unique> <silent> <Leader>o :tabo<CR>
" \m0 to move current tab as first one
silent! nnoremap <unique> <silent> <Leader>m0 :tabm0<CR>
" \m1 to move current tab as second one
silent! nnoremap <unique> <silent> <Leader>m1 :tabm1<CR>
" \m$ to move current tab to the last one
silent! nnoremap <unique> <silent> <Leader>m$ :tabm<CR>

" Commands
" \n to call :noh
silent! nnoremap <unique> <silent> <Leader>n :noh<CR>

" Plugins

" \N to open :NerdTree
silent! nnoremap <unique> <silent> <Leader>N :NERDTree<CR>

" \cpb to open CtrlP using buffer
silent! nnoremap <unique> <silent> <Leader>cpb :CtrlPBuffer<CR>
" \cpm to open CtrlP using MRU file mode
silent! nnoremap <unique> <silent> <Leader>cpm :CtrlPMRU<CR>
" \cpc to open customized path
silent! nnoremap <unique> <Leader>cpc :CtrlP<Space>

let g:solarized_termcolors=256
com! DCS exec ':colorscheme desert'
com! RCS exec 'let randcolor=[
            \"solarized",
            \"desert256",
            \"molokai", 
            \"rdark-terminal"
            \] | exe "colo " . randcolor[localtime() % len(randcolor)] | unlet randcolor'
com! RRCS exec 'let mycolors=split(globpath(&rtp,"**/colors/*.vim"),"\n") | exe "so " . mycolors[localtime() % len(mycolors)] | unlet mycolors'

"if has("win32")
    " Enable neocompl in windows

    " neocomplcache configuration
    " Launches neocomplcache automatically on vim startup.
    let g:neocomplcache_enable_at_startup = 1
    " Use smartcase.
    let g:neocomplcache_enable_smart_case = 1
    " Use camel case completion.
    let g:neocomplcache_enable_camel_case_completion = 1
    " Use underscore completion.
    let g:neocomplcache_enable_underbar_completion = 1
    " Sets minimum char length of syntax keyword.
    let g:neocomplcache_min_syntax_length = 3
    " buffer file name pattern that locks neocomplcache. e.g. ku.vim or fuzzyfinder 
    let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

    " Define file-type dependent dictionaries.
    let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

    " Define keyword, for minor languages
    if !exists('g:neocomplcache_keyword_patterns')
      let g:neocomplcache_keyword_patterns = {}
    endif
    let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    imap <C-k>     <Plug>(neocomplcache_snippets_expand)
    smap <C-k>     <Plug>(neocomplcache_snippets_expand)
    inoremap <expr><C-g>     neocomplcache#undo_completion()
    inoremap <expr><C-l>     neocomplcache#complete_common_string()

    " SuperTab like snippets behavior.
    "imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>  neocomplcache#close_popup()
    inoremap <expr><C-e>  neocomplcache#cancel_popup()

    " AutoComplPop like behavior.
    "let g:neocomplcache_enable_auto_select = 1

    " Shell like behavior(not recommended).
    "set completeopt+=longest
    "let g:neocomplcache_enable_auto_select = 1
    "let g:neocomplcache_disable_auto_complete = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
    "inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

    " Enable omni completion. Not required if they are already set elsewhere in .vimrc
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

    " Enable heavy omni completion, which require computational power and may stall the vim. 
    if !exists('g:neocomplcache_omni_patterns')
      let g:neocomplcache_omni_patterns = {}
    endif
    let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
    "autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
    let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"else
"    " YouCompleteMe in Linux
"endif

" Startup commands
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
au BufEnter * call LoadCscope()

" autoloading for cscope
function! LoadCscope()
    let db = findfile("cscope.out", ".;")
    if (!empty(db))
        let path = strpart(db, 0, match(db, "/cscope.out$"))
        set nocscopeverbose " suppress 'duplicate connection' error
        exe "cs add " . db . " " . path
        set cscopeverbose
    endif
endfunction

function! GenerateCscope(projpath)
    execute '!cd '. fnamemodify(a:projpath,':h') .' && find . -name *.php -o -name *.c -o -name *.cpp > cscope.files && cscope -b -i cscope.files && rm cscope.files;'
endfunction

" Generate CScope database
com! -nargs=* -complete=dir GCS call GenerateCscope(<f-args>)

"
" TODO: local config
" make sure this line is added as the first line before source this vimrc
" let g:phrepopath='~/dev/var/github/philia.test'
" let g:tempdir='/tmp'

" Uncomment these lines to enable plugins and customized config
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
