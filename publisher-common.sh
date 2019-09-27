#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"
PUBLISHER_SCRIPT_PATH="${1}"
RESULTS_PATH="${SCRIPT_PATH}/results"


###
# COMMONS #
###

. "${SCRIPT_PATH}/commons.sh"


###
# FUNCTIONS IMPLEMENTATION NECESSARY #
###

function publish_documents {
    fire_not_implemented
}


###
# FUNCTIONS #
###

function run_publisher {
    pushd "${RESULTS_PATH}"
    echo "Publishing documents"

    publish_documents

    break_if_error $? "Problem with publishing documents"

    echo "Publishing finished"
    popd
}


###
# INCLUDE IMPLEMENTATIONS #
###

# Invoke script passed as argument
# Includes functions and variables
. "${PUBLISHER_SCRIPT_PATH}"


###
# EXECUTE #
###

run_publisher
