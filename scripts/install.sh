#!/bin/bash

# Execution context
cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
    # Install the packages specified in requirements.txt
    echo unimplemented
else
    # Install defined packages
    for package in "$@"; do
        echo Installing $package
        pip3 install $package || exit 1
        pip3 freeze | grep -i $package >> requirements.txt
    done
fi

echo 
echo Requiremnets:
cat requirements.txt