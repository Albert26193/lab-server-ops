function cl() {
    if [[ -z ${1} ]]; then
        echo "please input the path"
        return
    fi

    cd ${1}
    local currentPath=$(pwd)
    local normalFileNum=$(ls -al | tail -n +4 | grep "^-" | wc -l | tr -d ' ')
    local dirFileNum=$(ls -al | tail -n +4 | grep "^d" | wc -l | tr -d ' ')

    local totalNum=$((${normalFileNum} + ${dirFileNum}))

    echo -e "\e[33m current path is: ${currentPath} \e[0m"
    echo -e "\e[35m total: ${totalNum} \e[0m"

    if [ ${totalNum} -le 15 ]; then
        ls -al
    elif [ ${totalNum} -ge 51 ]; then
        echo "files in current directory is more than 50"
    else
        ls -a
    fi
}
