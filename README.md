# lab-server-ops Documentation

- [1. Introduction](https://github.com/Albert26193/lab-server-ops#1-introduction)
	- [1.1 Overview](https://github.com/Albert26193/lab-server-ops#11-overview)
	- [1.2 Branch Description](https://github.com/Albert26193/lab-server-ops#12-branch-description)
	- [1.3 Feature Preview](https://github.com/Albert26193/lab-server-ops#13-feature-preview)
		- [1.3.1 User Distribution Feature](https://github.com/Albert26193/lab-server-ops#131-user-distribution-feature)
		- [1.3.2 User Broadcast Feature](https://github.com/Albert26193/lab-server-ops#132-user-broadcast-feature)
		- [1.3.3 User Basic Configuration](https://github.com/Albert26193/lab-server-ops#133-user-basic-configuration)
		- [1.3.4 Convenience Enhancement Feature](https://github.com/Albert26193/lab-server-ops#134-convenience-enhancement-feature)
- [2. Installation](https://github.com/Albert26193/lab-server-ops#2-installation)
	- [2.1 Confirm Branch](https://github.com/Albert26193/lab-server-ops#21-confirm-branch)
	- [2.2 Installation Process](https://github.com/Albert26193/lab-server-ops#22-installation-process)
		- [2.2.1 `linux` Branch](https://github.com/Albert26193/lab-server-ops#221-linux-branch)
		- [2.2.2 `linux-minimum` Branch](https://github.com/Albert26193/lab-server-ops#222-linux-minimum-branch)
		- [2.2.3`mac-personal` Branch](https://github.com/Albert26193/lab-server-ops#223-mac-personal-branch)
- [3. Usage](https://github.com/Albert26193/lab-server-ops#3-usage)
	- [3.1 For `Linux` Administrators](https://github.com/Albert26193/lab-server-ops#31-for-linux-administrators)
	- [3.2 For Ordinary Users](https://github.com/Albert26193/lab-server-ops#32-for-ordinary-users)
- [4. Configuration](https://github.com/Albert26193/lab-server-ops#4-configuration)
- [5. Development Plan](https://github.com/Albert26193/lab-server-ops#5-development-plan)

[中文](https://github.com/Albert26193/lab-server-ops/blob/linux/README_CN.md)

## 1. Introduction

### 1.1 Overview

- The target audience for this project:
  - `Linux` system administrators
  - Personal `Mac` users
  
---

- This project aims to provide a better terminal usage experience:
  - For administrators:
    1. Simplify the user distribution process (including permission isolation, group setting, key distribution, configuration of commonly used tools such as `zsh/vim/tmux`, etc.);
    2. Provide convenient user broadcast function;
  - For users:
      1. Rely on `oh-my-zsh` and its plugin ecosystem to get a convenient and comfortable `Shell` experience.
      2. Rely on the scripts provided by the `shell` programming of this project to implement a series of functions such as fuzzy jumping and history record fuzzy search.

### 1.2 Branch Description

- This project has a total of `3` branches:
  1. `linux` Branch: Suitable for mainstream `Linux` systems with `Linux kernel >= 5`, providing administrators with complete functions.
  2. `linux-minimum` Branch: Suitable for mainstream `linux` systems with `Linux kernel < 5`, providing administrators with some functions.
  3. `mac-personal` Branch: Suitable for `macOS`, providing individual users with some functions.

| Branch Name   | Adapted System                                          | Administrator Functions     | User Functions |
| ------------- | ------------------------------------------------------- | --------------------------- | -------------- |
| linux         | `Ubuntu(>= 19.04)`  `Debian/Raspbian >= 10.0`           | 1. User distribution; 2. User broadcast | 1. Common tool configuration 2. Convenience enhancement script |
| linux-minimum | `Ubuntu(< 19.04)`  `Debian/Raspbian < 10.0` `CentOS7/8` | 1. User distribution; 2. User broadcast | 1. Common user configuration |
| mac-personal  | `MacOS >= 11.0`                                         | No                          | 1. Convenience enhancement script |

### 1.3 Feature Preview

> The fuzzy jumping function largely relies on the two modern tools `fzf` and `fd`. This project is only a stitching tool for the glue layer.

#### 1.3.1 User Distribution Feature

- The administrator's user distribution function is fully interactive and can choose a series of functions such as user grouping, user permission `visudo` settings, user key distribution, etc.

![new-user.gif](https://img-20221128.oss-cn-shanghai.aliyuncs.com/img-2023-05/new-user.gif)

#### 1.3.2 User Broadcast Feature

- The essence of user broadcasting is that all users will load `/opt/lab-server-ops/lso_user/script_broadcast/broadcast.sh`
- Administrators only need to modify this file to implement the user broadcast function.

```shell
#.zshrc

# ------------------- broadcast ---------------------
bash "/opt/lab-server-ops/lso_user/script_broadcast/broadcast.sh"

```

#### 1.3.3 User Basic Configuration

- Users generated through distribution have pre-configured basic tools
- The `.vimrc/.zshrc/.tmux.conf` under the user's directory have been pre-configured
- The public and private keys under the user's directory `.ssh` have been pre-configured
#### 1.3.4 Convenience Enhancement Feature

- You can make fuzzy jumps and edits between directories
- You can fuzzy query the history record

![command.gif](https://img-20221128.oss-cn-shanghai.aliyuncs.com/img-2023-05/command.gif)

## 2. Installation

### 2.1 Confirm Branch

- Please make sure your system is one of `Deiban/Raspbian/Ubuntu/CentOS/MacOS`.
- If your system is `Ubuntu(>= 19.04)` or `Debian/Raspbian >= 10.0`, please execute

```shell
git checkout linux
```

- If your system is `Ubuntu(< 19.04)` or `Debian/Raspbian < 10.0` or `CentOS7/8`, please execute 

```shell
git checkout linux-minimum
```

- If your system is `macOS` please execute

```shell
git checkout mac-personal
```

> This project has the function of automatically detecting the operating system. If the branch does not meet the requirements, **automatic switching will be performed**

### 2.2 Installation Process

#### 2.2.1 `linux` Branch

1. Pull the project

```shell
git clone https://github.com/Albert26193/lab-server-ops.git

# branch: linux
git checkout linux
```

2. Install dependencies

```shell
# enter project
cd ./install

# install dependency
sudo bash install_dependency.sh
```

> The following dependencies will be installed

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

3. Install the project

```shell
sudo bash install.sh
```

4. Add administrator command entry

  > Please add the following command to your `.zshrc/.bashrc` according to your actual situation

```shell
source "/opt/lab-server-ops/lso_admin/lso.sh"
```

> Then execute the following command to reload the configuration file

```shell
source ~/.zshrc
# or  source ~/.bashrc
```

#### 2.2.2 `linux-minimum` Branch

1. Pull the project

```shell
git clone https://github.com/Albert26193/lab-server-ops.git

# branch: linux-minimum
git checkout linux-minimum
```

2. Install dependencies

```shell
# enter project
cd ./install

# install dependency
sudo bash install_dependency.sh
```

> The following dependencies will be installed

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

3.  Install the project

```shell
sudo bash install.sh
```

4. Add administrator command entry

  > Please add the following command to your `.zshrc/.bashrc` according to your actual situation

```shell
source "/opt/lab-server-ops/lso_admin/lso.sh"
```

> Then execute the following command to reload the configuration file

```shell
source ~/.zshrc
# or  source ~/.bashrc
```

#### 2.2.3`mac-personal` Branch

1. Pull the project

```shell
git clone https://github.com/Albert26193/lab-server-ops.git

# branch: mac-personal
git checkout mac-personal
```

2. Install dependencies

- 🛑 You need to ensure that `brew` is installed locally in advance

```shell
# enter project
cd ./install

# install dependency
bash install_dependency.sh
```

> The following dependencies will be installed

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

3. Install the project

```shell
bash install.sh
```

## 3. Usage

###  3.1 For `Linux` Administrators

  - After the installation is complete, your `.zshrc` or `.bashrc` should have added the command entry

```shell
source "/opt/lab-server-ops/lso_admin/lso.sh"
```

- Then, execute the following command

```shell
lso_admin
```

- The output is as follows

![image.png](https://img-20221128.oss-cn-shanghai.aliyuncs.com/img-2023-05/20240118165851.png)

- In the interactive panel, you will have two options
    1. Add new users: `useradd`, enter `1` 
    2. Add `zsh` related configuration for existing users: `addzsh`, enter `2`

- Then, you can interactively select user settings (grouping, key, creating symbolic links, etc.) 🍺️

### 3.2 For Ordinary Users

- The commands that ordinary users can get can be viewed in `.zshrc`

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

- `fs`: `fuzzy search` fuzzy search, accepts two parameters, can perform fuzzy matching on directories, its configuration please refer to `~/.lso.env`
- `fj`: `fuzzy jump` fuzzy jump, accepts two parameters, can perform fuzzy jump on directories, its configuration please refer to `~/.lso.env`
- `fe`: `fuzzy edit` fuzzy edit, accepts two parameters, can perform fuzzy edit on directories, its configuration please refer to `~/.lso.env`, the editor defaults to `vim`, you can replace it with other editors.
- `hh`: `fuzzy history` fuzzy history match, accepts two parameters, can perform fuzzy search and match on all `zsh` history records.
- `pon`: `proxy on`, can forward the current `shell` traffic, accepts two parameters, parameter 1 is the target server IP address, parameter 2 is the target server port
- `poff`: `proxy off`, turn off proxy

> If there are no related commands in `.zshrc`, it means that the `Linux` version is not enough, and the `linux-minimum` related commands are loaded

## 4. Configuration

- The configuration part is for the `.lso.env` file, this file controls the range of fuzzy adjustment and indexing, you can freely add `ignore` directories and query range directories.
- The default configuration is as follows

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
#lso_search
```

## 5. Development Plan

1. Add command audit function
2. Add administrator functions related to deleting users
3. Add administrator functions related to network and disk
