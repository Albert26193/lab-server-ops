#!bin/bash

###################################################
# description: download zsh and oh-my-zsh
#      return: 0: success | 1: fail
###################################################
function lso_zsh_download() {
    # Check if the script is sourced
    local lso_root="/opt/lab-server-ops"
    local util_file_path="${lso_root}/lso_utils/utils.sh"

    if [[ ! -f "${util_file_path}" ]]; then
        printf "%s\n" "${util_file_path} do not exist. Install lab-server-ops first."
        printf "%s\n" "Exit Now..."
        return 1
    else
        source "${util_file_path}"
        lso_print_info_line "lab-server-ops utils.sh sourced."
    fi

    # check user
    local current_user=$(whoami)
    if [[ -z "${current_user}" ]]; then
        lso_print_error_line "user is empty, please check it."
        return 1
    fi

    local current_home="$(eval echo ~${current_user})"

    if [[ ! -d "${current_home}" ]]; then
        lso_print_error_line "user home NOT EXIST, please check it."
        return 1
    fi

    # first check whether zsh is installed
    if [[ ! -x "$(which zsh)" ]]; then
        lso_print_error_line "zsh is not installed, please install it first."
        return 1
    fi

    # checkout whether oh-my-zsh is installed
    if [[ -e ${current_home}/.oh-my-zsh/oh-my-zsh.sh ]]; then
        lso_print_yellow_line "oh-my-zsh is already installed, nothing to do"
    else
        if [[ -e ${current_home}/.oh-my-zsh ]]; then
            lso_print_yellow_line "oh-my-zsh dir is already exist, but oh-my-zsh.sh not exist, remove it"
            rm -rf "${current_home}/.oh-my-zsh"
        fi

        export GIT_HTTP_LOW_SPEED_LIMIT=5
        export GIT_HTTP_LOW_SPEED_TIME=5

        lso_print_yellow_line "oh-my-zsh is not installed, install it now"
        lso_print_white_line "⏰️ wait for 10 seconds, this may take a while... ⏰️"
        lso_print_yellow_line "if FAILED, please check your network. cd to ${current_home} and run lso_zsh.sh again."

        # install oh-my-zsh
        bash -c "$(curl -m 5 -fsSL https://gitee.com/mirrors/ohmyzsh/raw/master/tools/install.sh)" "" --unattended >/dev/null

        if [[ ! -e ${current_home}/.oh-my-zsh/oh-my-zsh.sh ]]; then
            lso_print_yellow_line "oh-my-zsh install failed because of network."
            lso_print_white_line "Now, try to install oh-my-zsh from another gitee repo."
            bash -c "$(curl -m 5 -fsSL https://gitee.com/albert26193/ohmyzsh/raw/master/tools/install.sh)" "" --unattended >/dev/null
        fi

        if [[ ! -e ${current_home}/.oh-my-zsh/oh-my-zsh.sh ]]; then
            lso_print_yellow_line "oh-my-zsh install failed because of network."
            lso_print_white_line "Now, try to install oh-my-zsh from offical."
            bash -c "$(curl -m 5 -fsSL https://install.ohmyz.sh/)" >/dev/null
        fi

        if [[ ! -e ${current_home}/.oh-my-zsh/oh-my-zsh.sh ]]; then
            lso_print_yellow_line "oh-my-zsh install failed because of network."
            lso_print_white_line "Now, try to install oh-my-zsh from origin github repo."
            bash -c "$(curl -m 5 -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >/dev/null
        fi
    fi

    # install zsh-auto-suggestions
    if [[ -d ${current_home}/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
        lso_print_yellow_line "zsh-autosuggestions is already installed, nothing to do"
    else
        lso_print_cyan_line "zsh-autosuggestions is not installed, install it now"
        git clone https://gitee.com/albert26193/zsh-autosuggestions ${ZSH_CUSTOM:-${current_home}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

        if [[ $? -ne 0 ]]; then
            lso_print_yellow_line "plugin install failed because of network."
            lso_print_white_line "Now, try to install zsh-autosuggestions from origin github repo."
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${current_home}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            return 1
        fi
    fi

    # install zsh-syntax-highlighting
    if [[ -d ${current_home}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
        lso_print_yellow_line "zsh-syntax-highlighting is already installed, nothing to do"
    else
        lso_print_cyan_line "zsh-syntax-highlighting is not installed, install it now"
        git clone https://gitee.com/albert26193/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${current_home}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

        if [[ $? -ne 0 ]]; then
            lso_print_yellow_line "plugin install failed because of network."
            lso_print_white_line "Now, try to install zsh-syntax-highlighting from origin github repo."
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-${current_home}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            return 1
        fi
    fi

    # install zsh-completions
    if [[ -f "${current_home}/.zshrc" ]]; then
        lso_print_yellow_line "backup .zshrc to .zshrc.pre-oh-my-zsh"
        mv "${current_home}/.zshrc" "${current_home}/.zshrc.pre-oh-my-zsh"
    fi

    if [[ -f "${current_home}/template.zshrc" ]] &&
        [[ -f "${current_home}/template.vimrc" ]]; then
        lso_print_white_line "this is first time install, remove some files"
        # remove files not need
        rm "${current_home}/.zshrc"
        rm "${current_home}/.zsh_history"
        rm "${current_home}/.shell.pre-oh-my-zsh"
        rm "${current_home}/.zshrc.pre-oh-my-zsh"

        # create new .zshrc
        mv "${current_home}/template.zshrc" "${current_home}/.zshrc"
        mv "${current_home}/template.vimrc" "${current_home}/.vimrc"

        # source .zshrc
        source "${current_home}/.zshrc"
        rm "${current_home}/.zcompdump-*.zwc"
    fi
}

lso_zsh_download
