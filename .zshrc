if [ -z "$TMUX" ]; then
    echo TMUX not detected.
    if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        # detached session exists
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] ; then
            tmux attach-session
            exit
        elif [[ "$REPLY" == '' ]] || [[ "$REPLY" =~ ^[Nn]$ ]]; then
            tmux new-session
            exit

        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
            tmux attach -t "$REPLY"
            exit
        fi
    fi
    echo TMUX Running...
    mkdir -p ~/.termlog/`date +%y%m%d`
    tmux new-session \; pipe-pane 'cat > ~/.termlog/`date +%y%m%d/%H%M%S.log`'
    exit
fi

function lconf() {
    CONFF=${1:?"[ERROR] Augument error."}
    if [ -f $CONFF ];then
        . $CONFF
    else
        echo "[ERROR] ${CONFF} is not found."
    fi
}
CONF="${HOME}/.zsh"

for i in `ls ${CONF}/*.zshrc`
do
    lconf ${i}
done
