#!/bin/bash
function proxy_on() {
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
    curl cip.cc
}

function proxy_off() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo -e "proxy turn off"
    curl cip.cc
}
