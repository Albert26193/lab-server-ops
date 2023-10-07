# ---------------------- oh-my-zsh ----------------
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

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
alias "pc"="proxychains4"
alias "nv"="nvim"
alias "tm"="tmux"
alias "lg"="lazygit"
alias "ll"="ls -l"
alias "la"="ls -al"

# ---------------------  script  -------------------
my_scripts_dir="/opt/deploy_opt/scripts/"
my_scripts=(
    "script_utils/utils.sh"
    "script_shell/shell_cl.sh"
    "script_shell/shell_tree_du.sh"
    "script_shell/shell_man_nvim.sh"
    "script_out/out_go.sh"
    "script_fzf/fzf_source.sh"
    "script_fzf/fzf_grep.sh"
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

# ------------------- broadcast ---------------------
bash "/opt/deploy_opt/broadcast/broadcast.sh"
