
# lab-server-ops 说明文档

- [1.简介](#1-简介)
	- [1.1 概览](#11-概览)
	- [1.2 分支说明](#12-分支说明)
	- [1.3 功能预览](#13-功能预览)
		- [1.3.1 分发用户功能](#131-分发用户功能)
		- [1.3.2 用户广播功能](#132-用户广播功能)
		- [1.3.3 用户基本配置](#133-用户基本配置)
		- [1.3.4 便捷性增强功能](#134-便捷性增强功能)
- [2. 安装](#2-安装)
	- [2.1 确认分支](#21-确认分支)
	- [2.2 安装过程](#22-安装过程)
		- [2.2.1 `linux` 分支](#221-linux-分支)
		- [2.2.2 `linux-minimum` 分支](#222-linux-minimum-分支)
		- [2.2.3`mac-personal` 分支](#223-mac-personal-分支)
- [3. 使用](#3-使用)
	- [3.1 对于 `Linux` 管理员](#31-对于-linux-管理员)
	- [3.2 对于普通用户](#32-对于普通用户)
- [4. 配置](#4-配置)
- [5. 开发计划](#5-开发计划)

## 1.简介

### 1.1 概览

- 该项目的目标对象：
  - `Linux` 系统管理员
  - 个人 `Mac` 用户
  
---

- 此项目旨在提供更佳的终端使用体验：
  - 对于管理员：
    1. 简化分发用户的流程（包括权限隔离、设置分组、分发密钥、配置 `zsh/vim/tmux` 等常用工具等功能）；
    2.  提供便捷的用户广播功能；
  - 对于用户：
      1. 依靠 `oh-my-zsh` 和其生态下的插件框架，得到便捷舒适的 `Shell` 体验。
      2. 依靠本项目`shell` 编程提供的脚本，实现模糊跳转、历史记录模糊搜索等一系列功能。

### 1.2 分支说明

- 本项目一共有 `3` 个分支：
  1. `linux` 分支： 适配于 `Linux kernel >= 5` 的主流 `Linux` 系统，为**管理员**提供完整的功能。
  2. `linux-minimum` 分支：适配于 `Linux kernel < 5` 的主流 `linux` 系统，为**管理员**提供部分功能。
  3. `mac-personal` 分支：适配于 `macOS`，为**个人用户**提供部分功能。

| 分支名        | 适配系统                                                | 管理员功能             | 用户功能        |
| ------------- | ------------------------------------------------------- | ---------------------- | --------------- |
| linux         | `Ubuntu(>= 19.04)`  `Debian/Raspbian >= 10.0`           | 1.分发用户；2.用户广播 | 1. 常用工具配置 2. 便捷增强脚本 |
| linux-minimum | `Ubuntu(< 19.04)`  `Debian/Raspbian < 10.0` `CentOS7/8` | 1. 分发用户；2.用户广播                       | 1. 常用用户配置                |
| mac-personal  | `MacOS >= 11.0`                                         | 无                       | 1. 便捷增强脚本                |

### 1.3 功能预览

> 模糊跳转功能极大程度上依赖于 `fzf` 和 `fd` 这两个现代化工具，本项目仅仅只是一个胶水层的缝合工具。

#### 1.3.1 分发用户功能

- 管理员分发用户的功能是完全交互式的，可以选择：用户分组、用户权限 `visudo` 设置、用户密钥分发等一系列功能。

![new-user.gif](https://img-20221128.oss-cn-shanghai.aliyuncs.com/img-2023-05/new-user.gif)

#### 1.3.2 用户广播功能

- 用户广播的本质在于，所有的用户都会加载 `/opt/lab-server-ops/lso_user/script_broadcast/broadcast.sh` 
- 管理员只需要修改这个文件，就可以实现用户广播功能。

```shell
#.zshrc

# ------------------- broadcast ---------------------
bash "/opt/lab-server-ops/lso_user/script_broadcast/broadcast.sh"

```

#### 1.3.3 用户基本配置

- 经过分发产生的用户，基础工具具备预先配置
- 用户目录下的 `.vimrc/.zshrc/.tmux.conf` 都得到了预先配置
- 用户目录下的 `.ssh` 的公私密钥都得到了预先配置
#### 1.3.4 便捷性增强功能

- 可以在目录间模糊跳转、模糊编辑
- 可以模糊查询历史记录

![command.gif](https://img-20221128.oss-cn-shanghai.aliyuncs.com/img-2023-05/command.gif)

## 2. 安装

### 2.1 确认分支

- 请确保您的系统为 `Deiban/Raspbian/Ubuntu/CentOS/MacOS` 其中之一。
- 如果您的系统为 `Ubuntu(>= 19.04)` 或 `Debian/Raspbian >= 10.0`， 请执行

```shell
git checkout linux
```

- 如果您的系统为 `Ubuntu(< 19.04)` 或 `Debian/Raspbian < 10.0` 或 `CentOS7/8`，请执行 

```shell
git checkout linux-minimum
```

- 如果您的系统为 `macOS` 请执行

```shell
git checkout mac-personal
```

> 该项目具备自动检测操作系统的功能，如果分支不符合要求，**将会执行自动切换**

### 2.2 安装过程

#### 2.2.1 `linux` 分支

1. 拉取该项目

```shell
git clone https://github.com/Albert26193/lab-server-ops.git

# branch: linux
git checkout linux
```

2. 安装依赖

```shell
# enter project
cd lab-server-ops

# install dependency
sudo bash install_dependency.sh
```

> 以下依赖将会被安装

```shell
    local install=(
        "tmux"
        "vim"
        "git"
        "curl"
        "wget"
        "tree"
        "fd-find"
        "fzf"
        "bat"
        "exa"
        "nvim"
    )
```

3. 安装项目

```shell
sudo bash install.sh
```

4. 添加管理员命令入口

  > 请按照你的实际场景，将如下命令添加到你的 `.zshrc/.bashrc` 当中

```shell
source "/opt/lab-server-ops/lso_admin/lso.sh"
```

> 然后执行如下命令，重新加载配置文件

```shell
source ~/.zshrc
# or  source ~/.bashrc
```

#### 2.2.2 `linux-minimum` 分支

1. 拉取该项目

```shell
git clone https://github.com/Albert26193/lab-server-ops.git

# branch: linux-minimum
git checkout linux-minimum
```

2. 安装依赖

```shell
# enter project
cd lab-server-ops

# install dependency
sudo bash install_dependency.sh
```

> 以下依赖将会被安装

```shell
    local install=(
        "tmux"
        "vim"
        "git"
        "curl"
        "wget"
        "tree"
    )
```

3.  安装项目

```shell
sudo bash install.sh
```

4. 添加管理员命令入口

  > 请按照你的实际场景，将如下命令添加到你的 `.zshrc/.bashrc` 当中

```shell
source "/opt/lab-server-ops/lso_admin/lso.sh"
```

> 然后执行如下命令，重新加载配置文件

```shell
source ~/.zshrc
# or  source ~/.bashrc
```

#### 2.2.3`mac-personal` 分支

1. 拉取该项目

```shell
git clone https://github.com/Albert26193/lab-server-ops.git

# branch: mac-personal
git checkout mac-personal
```

2. 安装依赖

- 🛑 你需要提前确保本地安装了 `brew`

```shell
# enter project
cd lab-server-ops

# install dependency
bash install_dependency.sh
```

> 以下依赖将会被安装

```shell
    local install=(
        "tmux"
        "vim"
        "git"
        "curl"
        "wget"
        "tree"
        "fd"
        "fzf"
        "bat"
        "exa"
        "nvim"
    )
```

3. 安装项目

```shell
bash install.sh
```

## 3. 使用

###  3.1 对于 `Linux` 管理员

  - 安装完毕后，你的 `.zshrc` 或 `.bashrc` 当中，应该已经添加了命令入口

```shell
source "/opt/lab-server-ops/lso_admin/lso.sh"
```

- 然后，执行如下命令

```shell
lso_admin
```

- 输出如下

![image.png](https://img-20221128.oss-cn-shanghai.aliyuncs.com/img-2023-05/20240118165851.png)

- 在交互式面板当中，你将有两个选项
    1. 增加全新用户：`useradd`，输入 `1` 即可
    2. 为已有用户添加 `zsh` 相关配置：`addzsh`，输入 `2` 即可

- 接着，你可以交互式地选择用户设置（分组、密钥、建立软链接等）🍺️

### 3.2 对于普通用户

- 普通用户能够获取的命令可以在 `.zshrc` 当中查看

```shell
# ~/.zshrc

# ------------------  lab-server-ops ----------------

source "${HOME}/.lso.env"
source "/opt/lab-server-ops/lso_user/lso.sh"

alias "fs"="lso_fuzzy_search"
alias "fj"="lso_fuzzy_jump"
alias "fe"="lso_fuzzy_edit"
alias "hh"="lso_fuzzy_history"
alias "pon"="lso_proxy_on"
alias "poff"="lso_proxy_off"
```

- `fs`：`fuzzy search` 模糊查找，接收两个参数，可以对目录进行模糊匹配，其配置请参考 `~/.lso.env`
- `fj`：`fuzzy jump` 模糊跳转，接收两个参数，可以对目录进行模糊跳转，其配置请参考 `~/.lso.env`
- `fe`： `fuzzy edit` 模糊编辑，接收两个参数，可以对目录进行模糊编辑，其配置请参考 `~/.lso.env`，编辑器默认为 `vim` ，你可以替换为其他编辑器。
- `hh`：`fuzzy history` 模糊历史匹配，接收两个参数，可以对所有 `zsh` 的历史记录进行模糊查找和匹配。
- `pon`： `proxy on`，可以将当前 `shell` 的流量进行转发， 接收两个参数，参数1 为 目标服务器IP地址，参数2 为目标服务器端口
- `poff`: `proxy off`，关闭代理

> 如果 `.zshrc` 当中没有相关命令，说明 `Linux` 版本不够，加载的是 `linux-minimum` 相关命令

## 4. 配置

- 配置部分针对于 `.lso.env` 文件，这个文件控制了模糊调整和索引的范围，你可以自由添加 `ignore` 的目录和查询的范围目录。
- 默认配置如下

```shell
#!/bin/bash

# in which dir to search
lso_search_dirs=(
    "${HOME}"
    #"CodeSpace"
)

# within search range, which dir to ignore
lso_search_ignore_dirs=(
    # "Downloads"
    # "Desktop"
    # "Documents"
    ".git"
    ".local"
    ".m2"
    ".gradle"
    ".wns"
    ".nvm"
    ".npm"
    ".nrm"
    ".red-hat"
    ".redhat"
    ".oh-my-zsh"
    ".github"
    ".cache"
    ".cargo"
    ".rustup"
    ".vscode"
    ".vscode-insiders"
    ".vscode-server-insiders"
    ".vscode-server"
    ".vscode-oss"
    ".vscode-oss-insiders"
    "lib"
    "node_modules"
    "pkg"
    "bin"
    "dist"
    "pkgs"
    "from-github"
    "assets"
    "image"
    "images"
    "static"
    "data"
    "raycast"
    "obsidian-*"
    "zlt-*"
    "anaconda3"
    "Applications"
    "Library"
    "Movies"
    "Music"
    "Pictures"
    "Public"
    "Remote"
    "Zotero"
    "EVPlayer2_download"
)

# search preview or not, true: preview | false: not preview
# if your machine is not powerful enough(RAM <= 1GiB), set it to false
# otherwise, set it to true(Recommend)
lso_search_preview=true
#lso_search_preview=false

lso_editor="vim"
#lso_editor="nvim"
```

## 5. 开发计划

1. 增加命令审计功能
2. 增加删除用户相关的管理员功能
3. 增加网络、磁盘相关的管理员功能