#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"

TEMP_PATH="${SCRIPT_PATH}/temp"
RESULTS_PATH="${SCRIPT_PATH}/results"
DOCUMENTS_SCRIPTS_PATH="${SCRIPT_PATH}/documents"

###
# FUNCTIONS #
###

function print_space {
    echo
    echo "------------=========------------"
    echo
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

clear_temp
clear_results

run_all_documents
