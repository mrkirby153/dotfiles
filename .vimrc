set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
" === Plugins ===
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'cocopon/vaffle.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'rhysd/conflict-marker.vim'
" Plugin 'jiangmiao/auto-pairs'

Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'honza/vim-snippets'


Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-commentary'
Plugin 'godlygeek/tabular'
Plugin 'luochen1990/rainbow'
if executable('ctags')
    Plugin 'majutsushi/tagbar'
endif
Plugin 'machakann/vim-highlightedyank'

" Autocomplete
Plugin 'ycm-core/YouCompleteMe'

" PHP
Plugin 'spf13/PIV'
Plugin 'arnaud-lb/vim-php-namespace'
Plugin 'beyondwords/vim-twig'

" Python
Plugin 'klen/python-mode'
Plugin 'yssource/python.vim'
Plugin 'python_match.vim'
Plugin 'pythoncomplete'

" JavaScript
Plugin 'elzr/vim-json'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'briancollins/vim-jst'
Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'MaxMEllon/vim-jsx-pretty'

" HTML
Plugin 'alvan/vim-closetag'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'gko/vim-coloresque'
Plugin 'tpope/vim-haml'
Plugin 'mattn/emmet-vim'

" Miscelaneous
Plugin 'tpope/vim-markdown'
Plugin 'cespare/vim-toml'

" Fancy titlebar
Plugin 'vim-airline/vim-airline'
" Plugin 'bling/vim-bufferline'
Plugin 'vim-airline/vim-airline-themes'


Plugin 'arcticicestudio/nord-vim'

" Nix
Plugin 'LnL7/vim-nix'

call vundle#end()
filetype plugin indent on
" === END PLUGINS ===


" Vim Settings
set number
set linespace=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix
set background=dark
syntax on
set pastetoggle=<F3>

autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif " Automatically switch to current dir
set history=1000

" Restore Cursor on everything but git commit messages
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
function! ResCur()
    if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

set showmode
set cursorline
highlight clear SignColumn
highlight clear LineNr

if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
endif

set backspace=indent,eol,start

set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set scrolljump=5
set scrolloff=3
set foldenable
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" Formatting
set nowrap
set autoindent
set shiftwidth=4
set tabstop=4
set splitright
set splitbelow

autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2 " Files that must use spaces

" Easy move tabs and windows
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
map <C-H> <C-W>h
" Resize windows with arrow keys
map OB <C-W>-
map OA <C-W>+
map OD 5<C-W><
map OC 5<C-W>>
noremap j gj
noremap k gk

map <C-h> :noh<CR>

" Fix shift keys being dumb
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

cmap Tabe tabe

nnoremap Y Y$
'
" Dont exit visual mode when shifting
vnoremap < <gv
vnoremap > >gv

nnoremap q: <nop>
nnoremap Q <nop>

" === PLUGIN SETTINGS ===

" vim-php-namespace
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

" PIV
let g:DisableAutoPHPFolding = 0
let g:PIVAutoClose = 0

" Vaffle
map <F2> :Vaffle<CR>
" === END PLUGIN SETTINGS ===


set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

augroup muttSpell
    autocmd!
    autocmd BufRead,BufNewFile neomutt-* setlocal spell
augroup END


" Spellchecking
set spelllang=en_us

" Source vimrc.local for overrides if needed
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

colorscheme nord


if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.maxlinenr = '㏑'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline_symbols.whitespace = 'Ξ'

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ''



autocmd BufWritePost *sxhkdrc !/home/austin/.local/bin/start_sxhkd
