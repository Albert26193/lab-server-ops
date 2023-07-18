#!/bin/bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t rsa -b 4096 -C "${new_user}@nisl.com"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo "完成SSH秘钥配置"
#TODO: multiple keys?
