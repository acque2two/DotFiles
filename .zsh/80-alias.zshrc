# 何かしら省略形
alias ls="ls -F --color=auto -v"
alias la="ls -a"
alias ll="ls -l"
alias cp="cp --reflink=auto"
alias grep="grep --color"
alias clear="clear && archey3"
alias fbterm="fbterm --font-names=\"Ricty Discord\" --font-size=20"
alias pstree="pstree -A"
alias ping="ping -w 1 -c 1"
alias ps="ps ax"
alias -G inn="\| grep"
# 間違い減らし用（promptとかinterractiveとか）
alias rm="rm -i"
alias mv="mv -i"
alias mkdir="mkdir -p"

# viつかいにくい
alias vi="vim"


# 一文字エイリアス
alias t="top"
alias v="vim"
alias l="ls"

# 打ち間違い対処
alias ks="ls"
alias la="ls"
alias lks="ls"
alias ｌｓ="ls"
alias ext="exit"
alias えぃｔ="exit"
alias エィｔ="exit"
alias xit="exit"
alias it="exit"
alias quit="exit"
alias im="vim"

# nettools is duplicate.
alias ifconfig="echo '\e[31;2;5m[ERROR] net-tools is duplicate\!'; ip addr"
alias arp="echo '\e[31;1;5m[ERROR] net-tools is duplicate\!'; ip neigh"
alias route="echo '\e[31;1;5m[ERROR] net-tools is duplicate\!'; ip route"
alias netstat="echo '\e[31;1;5m[ERROR] net-tools is duplicate\!'; ss "

# Windowsのコマンドと間違えた時用
alias tracert="tracepath"
alias ipconfig="ip addr"

# sudo の後のコマンドでエイリアスを有効にする
alias sudo="sudo "

# 学校プロキシはクソ、はっきりわかんだね
## 透過プロキシくらいにはしてほしいなぁ
alias school="source ~/.bin/school"
alias school29="source ~/.bin/school29"
alias proxynone="source ~/.bin/my"

