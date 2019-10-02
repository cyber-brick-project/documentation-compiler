#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"

TEMP_PATH="${SCRIPT_PATH}/temp"
RESULTS_PATH="${SCRIPT_PATH}/results"
DOCUMENTS_SCRIPTS_PATH="${SCRIPT_PATH}/documents"
PUBLISHERS_SCRIPTS_PATH="${SCRIPT_PATH}/publishers"

PARAMETERS_EMPTY=true
PARAMETERS_CLEAN=false
PARAMETERS_RUN=false
PARAMETERS_PUSH=false
PUBLISHER_NAME=""


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
  -c              - clean TEMP and RESULTS paths
  -r              - run all documents
  -p [PUBLISHER]  - push documents to server using [PUBLISHER]
  -h              - print this help

Execution order (parameters order doesn't count):
- clean
- run
- push

Available Publishers:
`list_publishers`

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

function run_document {
    local DOCUMENT="${1}"

    print_space

    echo "Compile document:"
    echo "${DOCUMENT}"
    echo

    "${SCRIPT_PATH}"/document-common.sh "${DOCUMENT}";
}

function run_all_documents {
    echo "Compiling all documents"
    echo

    while IFS= read -r -d '' document; do
        run_document "${document}"
    done < <(find "${DOCUMENTS_SCRIPTS_PATH}" -iname '*.sh' -type f -print0)

    echo
    echo "Compiled"

    print_space
}

function list_publishers {
    while IFS= read -r -d '' publisher_name; do
        echo "$(basename "${publisher_name}" '.sh')"
    done < <(find "${PUBLISHERS_SCRIPTS_PATH}" -iname '*.sh' -type f -print0)
}

function check_publisher_exists {
    local PUBLISHER_NAME="${1}"

    if [ ! -f "${PUBLISHERS_SCRIPTS_PATH}/${PUBLISHER_NAME}.sh" ]; then
        break_if_error 1 "Publisher \"${PUBLISHER_NAME}\" do not exists"
    fi
}

function run_publisher {
    local PUBLISHER_NAME="${1}"

    print_space

    echo "Running publisher: \"${PUBLISHER_NAME}\""
    "${SCRIPT_PATH}"/publisher-common.sh "${PUBLISHERS_SCRIPTS_PATH}/${PUBLISHER_NAME}.sh"
}


###
# EXECUTE #
###

while getopts "crp:h" optname
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

            PUBLISHER_NAME="${OPTARG}"
            check_publisher_exists "${PUBLISHER_NAME}"
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

if $PARAMETERS_PUSH; then
    run_publisher "${PUBLISHER_NAME}"
fi
