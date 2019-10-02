#!/bin/bash ../publisher-common.sh

# publish_documents is executed in RESULTS_PATH directory
# Return 0 if succes. Otherwise error code.

function publish_documents {
    echo ""
    echo "Current path (pwd):"
    echo "`pwd`"
    echo ""
    echo "Content (ls -l):"
    echo "`ls -l`"

    return 1
}
