function ff {
    # 使用 fd 命令搜索文件，并传递 --hidden 参数来搜索隐藏文件
    local target_file="$(fs $1 $2)"
    local father_dir=$(dirname "${target_file}")
    cd ${father_dir} && nvim ${target_file}
}
