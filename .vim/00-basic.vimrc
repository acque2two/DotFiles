"
" 00-basic.vimrc
"   setで使える設定を記述していく場所
"   最初に適用されるべきな設定を書いていく。
"   できるだけ1行毎にコメントを書くこと。

" 基本的にUTF-8 Unicodeを使用する
set encoding=utf-8
" C言語オサワリマンだった名残でタブは4文字
set tabstop=4
set shiftwidth=4
set softtabstop=4
" インデントの自動化
set autoindent
" インデントのスマート化
set smartindent
" タブのスマート化
set smarttab
" タブはスペースに展開する
set expandtab
" ターミナルのタイトルをわかりやすく変更する
set title
" 行番号は大事
set number
" ルーラーはあったらうれしい
set ruler


set list

" インクリメントがまわるよ
set incsearch
" インファーケースる
set infercase
" バッファのスイッチ時にユーズをオープンする
set switchbuf=useopen
" バックスペースでインデントをエンドオブラインでスタートする
set backspace=indent,eol,start
" 検索対象たいしょう
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
set background=dark
