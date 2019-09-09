#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"

TEMP_PATH="${SCRIPT_PATH}/temp"
RESULTS_PATH="${SCRIPT_PATH}/results"
DOCUMENTS_SCRIPTS_PATH="${SCRIPT_PATH}/documents"

PARAMETERS_EMPTY=true
PARAMETERS_CLEAN=false
PARAMETERS_RUN=false
PARAMETERS_PUSH=false


###
# COMMONS #
###

. "${SCRIPT_PATH}/commons.sh"


###
# FUNCTIONS #
###

function print_help {
    cat << EOF
compile.sh - Script for recompiling and publishing documentations for Cyber Brick Project

No parameters works as 'compile.sh -c -r'

parameters:
  -c   - clean TEMP and RESULTS paths
  -r   - run all documents
  -p   - push documents to server using SCP
  -h   - print this help

Execution order (parameters order doesn't count):
- clean
- run
- push

https://github.com/cyber-brick-project
By mwilczek.net

EOF

    exit 0
}

function clear_directory {
    local DIR_NAME="${1}"
    local DIR_PATH="${2}"

    echo "Clear ${DIR_NAME}"
    echo

    echo "Remove \"${DIR_PATH}\""
    rm -rf "${DIR_PATH}"

    echo "Create \"${DIR_PATH}\""
    mkdir "${DIR_PATH}"

    print_space
}

function clear_temp {
    clear_directory "TEMP" "${TEMP_PATH}"
}

function clear_results {
    clear_directory "RESULTS" "${RESULTS_PATH}"
}

function run_all_documents {
    echo "Compiling all documents"
    echo

    find "${DOCUMENTS_SCRIPTS_PATH}" -iname '*.sh' -type f -print0 | xargs -0 -n 1 -I '{}' "${SCRIPT_PATH}"/document-common.sh "{}";

    echo
    echo "Compiled"

    print_space
}


###
# EXECUTE #
###

while getopts "crph" optname
do
    case "$optname" in
        "c")
            PARAMETERS_EMPTY=false
            PARAMETERS_CLEAN=true
            ;;
        "r")
            PARAMETERS_EMPTY=false
            PARAMETERS_RUN=true
            ;;
        "p")
            PARAMETERS_EMPTY=false
            PARAMETERS_PUSH=true
            break_if_error 1 "Pushing not implemented yet!"
            ;;
        *)
            print_help
            ;;
    esac
done


if $PARAMETERS_EMPTY; then
    PARAMETERS_CLEAN=true
    PARAMETERS_RUN=true
fi

if $PARAMETERS_CLEAN; then
    clear_temp
    clear_results
fi

if $PARAMETERS_RUN; then
    run_all_documents
fi