colorscheme desert
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

if exists("+autochdir")
    set autochdir
endif

set guitablabel="%r%m%t"

" show invisible chars like TAB
" set list
" set nolist

" fix issue about backspace doesn't work in insert mode
set backspace=2

"let g:netrw_browse_split=3 " open file in new tab
"let g:netrw_browse_split=0 " re-using the same window
let g:netrw_sort_direction='reverse'
" let g:netrw_bufsettings='noma nomod nu nobl nowrap ro'
let g:netrw_bufsettings='noma nomod relativenumber nobl nowrap ro'
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
    " set lines=62
    " set columns=110
    " maximize the window
    au GUIEnter * simalt ~X
    " hide menu bar
    set guioptions -=m
    " hide toolbar
    set guioptions -=T
    " hide right scrollbar
    set guioptions -=r
else
    let g:indent_guides_auto_colors = 1
    " hi IndentGuidesOdd ctermbg=lightgray
    " hi IndentGuidesEven ctermbg=darkgray
endif

" let g:Powerline_symbols = 'fancy'
" let g:Powerline_cache_enabled = 0
let g:Powerline_symbols = 'compatible'
let g:Powerline_stl_path_style = 'full'
let g:Powerline_dividers_override = ['>>', '>', '<<', '<']

let g:ctrlp_clear_cache_on_exit = 0

au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
" automatically opens netrw browser
" autocmd VimEnter * Ex
" this will help if 'set autochdir' doesn't work sometimes
" autocmd BufEnter * silent! lcd %:p:h

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
" \fdi to fold by indent
silent! nnoremap <unique> <silent> <Leader>fdi :set foldmethod=indent<CR>
" \fdm to fold by manual
silent! nnoremap <unique> <silent> <Leader>fdm :set foldmethod=manual<CR>

" Plugins
" \fe to open a new tab as the first one, then open netrw
silent! nnoremap <unique> <silent> <Leader>fe :0tabnew .<CR>

" \T to open taglist
silent! nnoremap <unique> <silent> <Leader>T :Tlist<CR>
" \E to open :Ex (netrw browse)
silent! nnoremap <unique> <silent> <Leader>E :Ex<CR>

" \ctc to open commant-T using input path
silent! nnoremap <unique> <Leader>ctc :CommandT<Space>

" \cpb to open CtrlP using buffer
silent! nnoremap <unique> <silent> <Leader>cpb :CtrlPBuffer<CR>
" \cpm to open CtrlP using MRU file mode
silent! nnoremap <unique> <silent> <Leader>cpm :CtrlPMRU<CR>
" \cpc to open customized path
silent! nnoremap <unique> <Leader>cpc :CtrlP<Space>

" \cq*   ConqueTerm series: v: vertical split, s: horizontal split, t: tab
silent! nnoremap <unique> <Leader>cqv :ConqueTermVSplit 
silent! nnoremap <unique> <Leader>cqs :ConqueTermSplit 
silent! nnoremap <unique> <Leader>cqt :ConqueTermTab 

" neocomplcache configuration
let g:neocomplcache_enable_at_startup=1
" Disable AutoComplPop. Comment out this line if AutoComplPop is not installed.
" let g:acp_enableAtStartup = 0
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


" TODO: local config
" make sure this line is added as the first line before source this vimrc
" source d:\dev\var\vimfiles\autoload\pathogen.vim
" source d:\dev\var\github\philia.test\vimrc
" Choose whether to enable or not
" set encoding=UTF-8
" for linux to display colors for powerline, this also affect indent-guides under msys
" set t_Co=256

" fix issue about "unable to open swap file for [No Name], recover impossible also this prevent .swp file from generating to current directory of netrw for Windows
" set dir=$TEMP for windows or set dir=/tmp for Linux
if has("win32")
    " set dir=$TEMP
    " set shell=D:/MinGW/msys/1.0/bin/bash.exe
    " set shellcmdflag=--login\ -c
else
    " set dir=$TMP
endif

" cd d:\work
" call pathogen#infect('d:\work\var\vimfiles\bundle')
" call pathogen#helptags()
" where bookmarks and history are saved (as .netrwbook and .netrwhist), must be configured because of bugs of netrw, it saves .netrwbook and .netrwhist to the first folder in bundle
" let g:netrw_home='d:\dev\tmp'

" let g:netrw_scp_cmd='d:\dev\utils\pscp.exe -i d:\dev\keys\private.ppk'
" let g:netrw_list_cmd='d:\dev\utils\plink.exe USEPORT HOSTNAME -i d:\dev\keys\private.ppk ls -aF'
" usage:
" :e scp://root@ip//path/filename to open file
" :e scp://root@ip//path/ to open path (remember the last / is very important for open remote directory)
