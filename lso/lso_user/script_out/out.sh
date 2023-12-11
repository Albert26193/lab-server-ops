#!/bin/bash

###################################################
# description: proxy on
#       input: $1: target ip address
#       input: $2: target port number
#      return: 0: success | 1: fail
###################################################
function lso_proxy_on() {
    local proxy_ip_address="127.0.0.1"
    local port="7890"

    if [[ -n "$1" ]]; then
        proxy_ip_address="$1"
    fi

    if [[ -n "$2" ]]; then
        port="$2"
    fi

    export http_proxy="http://${proxy_ip_address}:${port}"
    export https_proxy="http://${proxy_ip_address}:${port}"
    export all_proxy="socks5://${proxy_ip_address}:${port}"
    echo -e "proxy on, ip is ${proxy_ip_address}, port is ${port}"

    local google_result=$(curl -s --connect-timeout 3 -m 3 www.google.com)
    if [[ -z "${google_result}" ]]; then
        echo -e "proxy on failed, please check it."
        return 1
    else
        echo -e "proxy on success.🚀️🚀️🚀️"
        echo -e "your curl google's data length is: ${#google_result}"
        return 0
    fi
}

###################################################
# description: proxy off
#       input: none
#      return: 0: success | 1: fail
###################################################
function lso_proxy_off() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "proxy turn off🌙️"
    curl cip.cc
    return 0
}
