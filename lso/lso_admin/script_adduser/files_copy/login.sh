#!/bin/bash

function login_campus() {
    local URL="https://10.108.255.249/include/auth_action.php"

    #######################################################
    # ⚠️ replace with your own username and password
    #######################################################
    local username="YOUR_NAME"
    local password="YOUR_PASSWORD"

    if [[ "$(which curl)" ]]; then
        echo "curl found, try to use it..."
        local result_curl="$(curl $URL --insecure --data "action=login&username=$username&password=$password&ac_id=1&nas_ip=&user_mac=&save_me=1&ajax=1")"
        echo "${result_curl}"
        exit 1
    else
        echo "curl not found, please install it first."
        echo "Try to switch to wget..."
    fi

    if [[ "$(which wget)" ]]; then
        echo "wget found, try to use it..."
        local resut_wget="$(wget --no-check-certificate --post-data="action=login&username=$username&password=$password&ac_id=1&nas_ip=&user_mac=&save_me=1&ajax=1" -qO- $URL)"
        echo "${resut_wget}"
        exit 0
    else
        echo "wget not found, please install it first."
    fi

    echo "both curl and wget not found, exit now."
    exit 1
}

login_campus
