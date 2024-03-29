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

function compilation_variables_file_name {
    fire_not_implemented
}

function compilation_variables {
    fire_not_implemented
}

###
# HELPERS #
###

function generate_compilation_variable {
    local VARIABLE_NAME="${1}"
    local VARIABLE_VALUE="${2}"

    cat << EOF

\ifdefined${VARIABLE_NAME}
    \renewcommand{${VARIABLE_NAME}}{${VARIABLE_VALUE}}
\else
    \newcommand{${VARIABLE_NAME}}{${VARIABLE_VALUE}}
\fi

EOF
}

function count_in_tex {
    local WHAT_TO_FIND="${1}"
    find . -iname '*.tex' | xargs grep -o "${WHAT_TO_FIND}" | wc -l
}


###
# FUNCTIONS #
###

function check_implementations {
    repository_path
    repository_name
    repository_branch
    document_file_name
    document_destination_file_name
    compilation_variables_file_name
    compilation_variables
}

function print_document_details {
    echo "Document details:"
    echo
    echo "  Document respository name: \"$(repository_name)\""
    echo "  Document respository path: \"$(repository_path)\""
    echo "  Document branch: \"$(repository_branch)\""
    echo "  Document source name: \"$(document_file_name)\""
    echo "  Document destination name: \"$(document_destination_file_name)\""
    echo "  Compilation variables file name: \"$(compilation_variables_file_name)\""
    echo "  Compilation variables:"
    compilation_variables

    print_space
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

function prepare_compilation_variables {
    echo "Prepare compilation variables file\"$(compilation_variables_file_name)\""
    echo
    pushd "${TEMP_PATH}/$(repository_name)"

    if [ -z "$(compilation_variables_file_name)" ]; then
        echo "NO VARIABLES FILE! SKIPPING!"
        return
    fi

    touch "$(compilation_variables_file_name)"
    break_if_error $? "Problem with creating file for custom variables"

    compilation_variables >> "$(compilation_variables_file_name)"

    popd
    print_space
}

function count_required_compilation_passes {
    local INCLUDE_COUNT=`count_in_tex '\cbpInclude'`
    local EMPTY_PAGE_IF_ODD_COUNT=`count_in_tex '\cbpEmptyPageIfTwosideOdd'`
    local EMPTY_PAGE_IF_EVEN_COUNT=`count_in_tex '\cbpEmptyPageIfTwosideEven'`
    local SUM_ALL="$(($INCLUDE_COUNT+$EMPTY_PAGE_IF_ODD_COUNT+$EMPTY_PAGE_IF_EVEN_COUNT))"

    echo "${SUM_ALL}"
}

function compile_pdf_command {
    pdflatex -synctex=1 -interaction=nonstopmode "$(document_file_name)"
    break_if_error $? "Problem with compiling PDF"
}

function compile_pdf {
    echo "Compile PDF from \"$(document_file_name)\""
    echo
    pushd "${TEMP_PATH}/$(repository_name)"

    # Multiple compilation required by LaTeX
    # After generating code, page numbers, TOC, empty pages must be recalculated
    local REQUIRED_PASSES_NUMBER="$(count_required_compilation_passes)"
    echo "Required compilation passes: ${REQUIRED_PASSES_NUMBER}"
    for (( i=0; i<$REQUIRED_PASSES_NUMBER; i++ )) do
        echo
        echo "PASS NUMBER ${i}"
        echo
        compile_pdf_command
    done

    popd
}

function move_pdf_to_results {
    echo "Compile move result to \"$(document_destination_file_name)\""
    echo
    pushd "${TEMP_PATH}/$(repository_name)"

    mv "$(basename "$(document_file_name)" .tex).pdf" "${RESULTS_PATH}/$(document_destination_file_name)"
    break_if_error $? "Problem with moving PDF"

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

check_implementations

print_document_details

git_clone
git_branch_and_submodules
prepare_compilation_variables
compile_pdf
move_pdf_to_results
