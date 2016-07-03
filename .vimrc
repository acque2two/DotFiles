set encoding=utf-8
scriptencoding utf-8

set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent
set smarttab
set expandtab

set title

set number
set ruler
set list
set incsearch
set infercase
set switchbuf=useopen
"set matchpairs& matchpairs+=<:>,":",':'
set backspace=indent,eol,start
set hlsearch
set nowrap
set showmatch
set matchtime=1
set ignorecase
set smartcase
set helplang=en
set listchars=tab:\ \ ,trail:-,nbsp:%,extends:>,precedes:<
set display=lastline
set pumheight=8
set mouse=a
set shortmess+=I

set showcmd
set cmdheight=2
set scrolloff=5
set cindent

set wildmenu

set laststatus=2

highlight LineNr ctermfg=darkyellow

colorscheme desert256
nnoremap <Space>w  :<C-u>w<CR>
nnoremap <Space>q  :<C-u>q<CR>
nnoremap <Space>Q  :<C-u>q!<CR>
nnoremap Y y$
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'))

filetype plugin indent off
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim
endif

augroup SkeletonAu
	autocmd!
	autocmd BufNewFile *.py 0r $HOME/.vim/skel.py
    autocmd BufNewFile *.c 0r $HOME/.vim/skel.c
    autocmd BufNewFile *.cpp 0r $HOME/.vim/skel.cpp
augroup END

set background=dark

call neobundle#begin(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'tpope/vim-endwise'
"(C-'-')x2 -> Comment In/Out


" 行末の半角スペースを可視化
NeoBundle 'bronson/vim-trailing-whitespace'

let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ }


" ファイルオープンを便利に
NeoBundle 'Shougo/unite.vim'
" Unite.vimで最近使ったファイルを表示できるようにする
NeoBundle 'Shougo/neomru.vim'

" ファイルをtree表示してくれる
NeoBundle 'scrooloose/nerdtree'

" Gitを便利に使う
NeoBundle 'tpope/vim-fugitive'

" grep検索の実行後にQuickFix Listを表示する
autocmd QuickFixCmdPost *grep* cwindow

" Ruby向けにendを自動挿入してくれる
NeoBundle 'tpope/vim-endwise'

" コメントON/OFFを手軽に実行
NeoBundle 'tomtom/tcomment_vim'

" シングルクオートとダブルクオートの入れ替え等
NeoBundle 'tpope/vim-surround'

" インデントに色を付けて見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'
"
" ログファイルを色づけしてくれる
NeoBundle 'vim-scripts/AnsiEsc.vim'

NeoBundle 'apple-swift', {'type': 'nosync', 'base': '~/.vim/bundle/manual'} 
" " vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1


NeoBundle 'itchyny/lightline.vim'

call neobundle#end()

filetype plugin indent on

if has("autocmd")
    autocmd BufReadPost *
		\ if line("'\"") > 0 && line ("'\"") <= line("$") |
		\   exe "normal! g'\"" |
		\ endif
endif
syntax on
au BufRead,BufNewFile *.md set filetype=markdown

augroup MyXML
    autocmd!
    autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
    autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
augroup END

imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>

inoremap <C-l> <Esc>$i
inoremap <C-h> <Esc>^i
inoremap <C-j> <Esc>Gi
inoremap <C-k> <Esc>ggi
noremap <C-l> <Esc>$
noremap <C-h> <Esc>^
noremap <C-j> <Esc>G
noremap <C-k> <Esc>gg


