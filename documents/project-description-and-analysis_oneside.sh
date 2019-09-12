#!/bin/bash ../document-common.sh

function repository_path {
    echo "https://github.com/cyber-brick-project/project-description-and-analysis.git"
}

function repository_name {
    echo "project-description-and-analysis.git.oneside"
}

function repository_branch {
    echo "doc"
}

function document_file_name {
    echo "Documentation.tex"
}

function document_destination_file_name {
    echo "project-description-and-analysis_oneside.pdf"
}

function compilation_variables_file_name {
    echo "automatic_compilation_variables.tex"
}

function compilation_variables {
    generate_compilation_variable "\cbpDocumentSides" "oneside"
}
