" =================================
" ============ 基本设置 ===========
" =================================
set number            " 设置行号
set nocompatible      " 设置和vi不兼容
syntax on             " 开启语法高亮 
set showcmd           " 显示命令
set encoding=utf-8    " 设置编码为utf-8
set t_Co=256          " 设置颜色是256色
filetype indent on    " 开启类型检查
set autoindent        " 设置自动缩进
set tabstop=2         " 按下Tab之后显示的空行数
set shiftwidth=4      " 设置缩进(<<)空格数为4
set expandtab         " 将Tab 转成空格
set softtabstop=2     " Tab转成的空格数量

" =================================
" ============ 外观设置 ===========
" =================================
set textwidth=80      " 设置行宽
set wrap              " 自动折行
set linebreak         " 遇到特殊才会折行，单词内部不折行
set scrolloff=5       " 光标距离顶部/底部距离
set laststatus=2      " 始终显示状态
set ruler             " 在状态栏显示当前光标位置
set showmatch         " 遇到另外一个括号，自动高亮
set hlsearch          " 高亮搜索结果
set incsearch         " 每输入一个字符，就自跳转匹配位置
set ignorecase        " 搜索时无视大小写
set wildmenu          " 设置vim 命令补全
set wildmode=longest:list,full
