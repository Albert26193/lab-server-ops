#!/bin/bash

###################################################
# description: install dependency
#       input: none
#      return: 0: success | 1: fail
###################################################

function pre_install {
    local common_install=(
        "tmux"
        "rsync"
        "zip"
        "unzip"
        "vim"
        "git"
        "curl"
        "wget"
        "tree"
    )

    local debian12_install=(
        "fd-find"
        "fzf"
        "duf"
        "neofetch"
        "bat"
        "neovim"
        "xclip"
        "jq"
        "yq"
        "exa"
        "ripgrep"
    )

    local ubuntu_to_install_list=(
        "fd-find"
        "fzf"
        "duf"
        "tmux"
        "neofetch"
        "bat"
        "xclip"
        "jq"
        "yq"
        "exa"
        "ripgrep"
    )

    for package in "${to_install_list[@]}"; do
        if ! dpkg -l | grep -q "^ii[ ]* ${package}"; then
            printf '%s\n' "${package} is not installed. Installing..."
            sudo apt-get update && sudo apt-get install -y "${package}"
        else
            printf '%s\n' "${package} is already installed."
        fi
    done
}

pre_install
