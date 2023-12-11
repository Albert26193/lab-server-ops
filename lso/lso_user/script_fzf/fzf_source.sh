#!/bin/bash

lso_search_dirs=()
lso_search_ignore_dirs=()
lso_search_preview="false"
lso_search_editor=""

###################################################
# description: parse yaml file
#       input: $1: file to parse
#       input: $2: parse expression
#      return: 0: exist | 1: not exist
###################################################
function lso_parse_yaml {
    local file_to_parse="$1"
    local expression="$2"
    local yaml_array=()

    while IFS= read -r line; do
        yaml_array+=($line)
    done < <(yq "$expression" "$file_to_parse")

    if [[ $? -ne 0 ]]; then
        echo "Error: parse yaml file failed."
        return 1
    fi

    echo ${yaml_array[@]}
    return 0
}

###################################################
# description: source fuzzy search dirs and ingore dirs
#       input: none
#      return: 0 success | 1 fail
###################################################
function lso_fuzzy_load() {
    # load lso config
    local lso_conf="${HOME}/.lso.yaml"

    if [[ ! -f "${lso_conf}" ]]; then
        printf "%s\n" "${lso_conf} do not exist."
        return 1
    fi

    lso_search_dirs=($(lso_parse_yaml "${lso_conf}" ".search_dirs[]"))
    lso_search_ignore_dirs=($(lso_parse_yaml "${lso_conf}" ".search_ignore_dirs[]"))
    lso_search_preview=($(lso_parse_yaml "${lso_conf}" ".search_preview.enable"))
    lso_search_editor=($(lso_parse_yaml "${lso_conf}" ".search_editor"))
}

lso_fuzzy_load
