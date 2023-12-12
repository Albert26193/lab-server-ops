# ---------------------- oh-my-zsh ----------------
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="ys"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions docker)

HISTFILE="${ZSH}/cache/.zsh_history"
ZSH_COMPDUMP="${ZSH}/cache/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

source $ZSH/oh-my-zsh.sh

# --------------------- zsh -----------------------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=blue'

# --------------------- general -------------------
export TERM="xterm-256color"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LS_COLORS=${LS_COLORS}:'di=01;35'

#  --------------------- alias --------------------
alias "nv"="nvim"
alias "tm"="tmux"
alias "ll"="ls -l"
alias "la"="ls -al"

# ------------------  lab-server-ops script  ----------------
source "~/.lso.env"
my_scripts_dir="/opt/lab-server-ops/lso_user/"
my_scripts=(
    "script_out/out.sh"
    "script_fzf/fzf_search.sh"
    "script_fzf/fzf_history.sh"
)

for single_script in "${my_scripts[@]}"; do
    current_script="${my_scripts_dir}${single_script}"
    if [[ ! -f ${current_script} ]]; then
        echo "${current_script} does not exist"
    else
        source "${current_script}"
    fi
done

alias "fs"="lso_fuzzy_search"
alias "fj"="lso_fuzzy_jump"
alias "fe"="lso_fuzzy_edit"
alias "hh"="lso_fuzzy_history"

# ------------------- broadcast ---------------------
bash "/opt/lab-server-ops/lso_user/script_broadcast/broadcast.sh"
