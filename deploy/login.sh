#!/bin/bash

URL="https://10.108.255.249/include/auth_action.php"
username="${YOUR_NAME}"
password="${YOUR_PASSWORD}"

result=$(curl $URL --insecure --data "action=login&username=$username&password=$password&ac_id=1&nas_ip=&user_mac=&save_me=1&ajax=1")

echo $result
