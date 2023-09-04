function cl() {
    cd ${1}
    local currentPath=$(pwd)
    local normalFileNum=$(ls -al | grep "^-" | wc -l | tr -d ' ')
    local dirFileNum=$(ls -al | grep "^d" | wc -l | tr -d ' ')
    # totalNum=`expr ${normalFileNum} + ${dirFileNum}`
    local totalNum=$((${normalFileNum} + ${dirFileNum}))
    echo -e "\e[33m current path is: ${currentPath} \e[0m"
    echo -e "\e[35m total: ${totalNum} \e[0m"

    if [ ${totalNum} -le 15 ]; then
        exa -al
    elif [ ${totalNum} -ge 51 ]; then
        echo "files in current directory is more than 50"
    else
        exa -a
    fi
}
