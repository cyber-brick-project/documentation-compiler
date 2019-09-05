#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"

TEMP_PATH="${SCRIPT_PATH}/temp"

function clear_temp {
    echo "Clear temp"
    echo

    echo "Remove \"${TEMP_PATH}\""
    rm -rf "${TEMP_PATH}"

    echo "Create \"${TEMP_PATH}\""
    mkdir "${TEMP_PATH}"
}


clear_temp
