#!/bin/bash

# Constants
reqs=requirements.txt

# Execution context
cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    # Install the packages specified in requirements.txt
    echo Installing requirements...
    pip3 install -r $reqs
else
    # Install defined packages
    for package in "$@"; do
        echo Installing $package
        pip3 install $package || exit 1
        pip3 freeze | grep -i $package >> $reqs
    done

    echo
    echo Requiremnets:
    cat $reqs
fi 