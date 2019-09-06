#!/bin/bash

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)"
DOCUMENT_SCRIPT_PATH="${1}"
TEMP_PATH="${SCRIPT_PATH}/temp"
RESULTS_PATH="${SCRIPT_PATH}/results"

###
# COMMONS #
###

. "${SCRIPT_PATH}/commons.sh"

###
# FUNCTIONS IMPLEMENTATION NECESSARY #
###

function repository_path {
    fire_not_implemented
}

function repository_name {
    fire_not_implemented
}

function repository_branch {
    fire_not_implemented
}

function document_file_name {
    fire_not_implemented
}

function document_destination_file_name {
    fire_not_implemented
}

###
# FUNCTIONS #
###

function fire_not_implemented {
    local NOT_IMPLEMENTED_NAME="${FUNCNAME[1]}"

    print_error "Function \"${NOT_IMPLEMENTED_NAME}\" is not implemented"
    exit 1
}

function git_clone {
    echo "Cloning repository \"$(repository_name)\""
    echo

    pushd "${TEMP_PATH}"

    git clone "$(repository_path)" "$(repository_name)"
    break_if_error $? "Problem with cloning repository"

    popd
    print_space
}

function git_branch_and_submodules {
    echo "Change branch to \"$(repository_branch)\""
    echo

    pushd "${TEMP_PATH}/$(repository_name)"
    git checkout "$(repository_branch)"
    break_if_error $? "Problem with changing branch"

    echo
    echo "Init submodules"
    echo

    git submodule update --init --recursive
    break_if_error $? "Problem with submodules update"

    popd
    print_space
}

function compile_pdf_command {
    pdflatex -synctex=1 -interaction=nonstopmode "$(document_file_name)"
    break_if_error $? "Problem with compiling PDF"
}

function compile_pdf {
    echo "Compile PDF from \"$(document_file_name)\""
    echo

    pushd "${TEMP_PATH}/$(repository_name)"

    # Double compilation required by LaTeX
    compile_pdf_command
    compile_pdf_command

    popd
}

function move_pdf_to_results {
    echo "Compile move result to \"$(document_destination_file_name)\""
    echo

    pushd "${TEMP_PATH}/$(repository_name)"

    mv "$(basename "$(document_file_name)" .tex).pdf" "${RESULTS_PATH}/$(document_destination_file_name)"
    break_if_error $? "Problem moving PDF"

    popd
}

###
# INCLUDE IMPLEMENTATIONS #
###

# Invoke script passed as argument
# Includes functions and variables
. "${DOCUMENT_SCRIPT_PATH}"


###
# EXECUTE #
###

echo "Document details:"
echo
echo "  Document respository name: \"$(repository_name)\""
echo "  Document respository path: \"$(repository_path)\""
echo "  Document branch: \"$(repository_branch)\""
echo "  Document source name: \"$(document_file_name)\""
echo "  Document destination name: \"$(document_destination_file_name)\""

print_space

git_clone
git_branch_and_submodules
compile_pdf
move_pdf_to_results
