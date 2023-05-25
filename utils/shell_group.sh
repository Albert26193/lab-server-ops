#!/bin/bash

# 要查找的用户名 
username=$1

# 如果未输入用户名,提示输入 
if [ -z "$username" ]; then
  read -p "请输入要查找的用户名:" username
fi

# 查看用户的主要组和附属组 
groups=$(id -Gn $username)

# 打印用户信息和组 
echo "用户:$username" 
echo "主组:$(id -gn $username)"
echo "附属组:$groups"

# 读取组列表并打印详细信息 
for group in $groups; do
  echo "组:$group"
  echo "组GID:$(getent group $group | cut -d: -f2)" 
  echo "组成员:$(getent group $group | cut -d: -f4)"
  echo 
done

# 提示 
echo "用户 $username 属于以上列出的组。"