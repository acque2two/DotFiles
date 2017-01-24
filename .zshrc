if [ -z "$TMUX" ]; then
    echo TMUX not detected.
    if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        tmux list-sessions
        echo -n "attach (Y/n/num) "
        read
        if [[ "$REPLY" == '' ]] || [[ "$REPLY" =~ ^[Yy]$ ]] ; then
            tmux attach-session
        elif [[ "$REPLY" =~ ^[Nn]$ ]]; then
            tmux new-session
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
            tmux attach -t "$REPLY"
        fi
        exit
    fi
    echo TMUX New session Starting...
    tmux new-session \; pipe-pane 'cat > ~/.termlog/`date +%y%m%d/%H%M%S.log`'
    exit
fi

if [ -z "$SCRIPTED" ]; then
    LOGGING="/home/acq/.termlog/`date +%y%m%d`/ZSH_`date +%H%M%S`_`date +%N`.log"
    echo Not scripted. script starting...
    mkdir -p ~/.termlog/`date +%y%m%d`
    export SCRIPTED=TRUE
    script $LOGGING --timing=$LOGGING.timing
    exit
fi

for i in `ls ${HOME}/.zsh/*.zshrc`
do
    . $i
done
export GOPATH=~/.go
