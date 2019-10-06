#!/bin/bash

function print_space {
    echo
    echo "------------=========------------"
    echo
}

function print_error {
    print_space

    echo
    echo " !!! ERROR !!! "
    echo
    echo "${1}"
    echo

    print_space
}

function break_if_error {
    RESULT_CODE=$1
    ERROR_MESSAGE="${2}"
    if [ $RESULT_CODE -ne 0 ]; then
        print_error "${ERROR_MESSAGE}"

        exit $RESULT_CODE
    fi
}

function fire_not_implemented {
    local NOT_IMPLEMENTED_NAME="${FUNCNAME[1]}"

    print_error "Function \"${NOT_IMPLEMENTED_NAME}\" is not implemented"
    exit 1
}