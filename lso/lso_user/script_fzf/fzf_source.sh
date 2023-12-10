#!/bin/bash

FUZZY_SEARCH_DIRS=()
FUZZY_SEARCH_IGNORE_DIRS=()
FUZZY_SEARCH_PREVIEW="false"
FUZZY_SEARCH_EDITOR=""

FUZZY_GREP_DIRS=()
FUZZY_GREP_IGNORE_DIRS=()
FUZZY_GREP_EDITOR=""

function source_fuzzy_dirs {
    local fuzzy_search_conf="${HOME}/.fuzzy_conf.yaml"

    if [[ ! -f "${fuzzy_search_conf}" ]]; then
        printf "%s\n" "${fuzzy_search_conf} do not exist."
        return 1
    fi

    FUZZY_SEARCH_DIRS=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_search_dirs[]"))
    FUZZY_SEARCH_IGNORE_DIRS=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_search_ignore_dirs[]"))
    FUZZY_SEARCH_PREVIEW=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_search_preview.enable"))
    FUZZY_SEARCH_EDITOR=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_search_editor"))

    FUZZY_GREP_DIRS=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_grep_dirs[]"))
    FUZZY_GREP_IGNORE_DIRS=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_grep_ignore_dirs[]"))
    FUZZY_GREP_EDITOR=($(utils_parse_yaml "${HOME}/.fuzzy_conf.yaml" ".fuzzy_search_editor"))
}

source_fuzzy_dirs
