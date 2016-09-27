setopt share_history
setopt hist_save_no_dups
setopt hist_reduce_blanks

#####################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# ビープの無効化
setopt no_beep

# Ctrl+Dの無視
setopt ignore_eof

# コメントの有効化
setopt interactive_comments

#autoload predict-on
#predict-on

# cd快適化
setopt auto_cd

# popdで戻れるように
setopt auto_pushd

# 繰り返したコマンドを履歴に保存しない
setopt hist_ignore_all_dups

# 履歴に保存するときに余分なスペースを削除
setopt hist_reduce_blanks

# ワイルドカード展開を使用
setopt extended_glob

setopt notify
setopt correct

setopt magic_equal_subst
setopt auto_list
setopt auto_menu
setopt list_types

setopt complete_aliases
setopt auto_param_keys
setopt auto_param_slash
setopt mark_dirs
setopt complete_in_word
setopt always_last_prompt
setopt print_eight_bit

setopt autoremoveslash
setopt transient_rprompt
setopt interactive_comments
setopt multios
setopt short_loops

setopt no_flow_control

# 前にヒストリをgitにあげて「お前の動画閲覧履歴が上がってるぞ」とIssueで言われたので
# スペースを入れてコマンドを実行するとヒストリに残らなくなる
setopt HIST_IGNORE_SPACE
