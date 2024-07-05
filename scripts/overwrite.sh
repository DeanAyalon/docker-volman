#!/bin/sh

# Only run within volman
if [ $(hostname) != "volman" ]; then
    echo This script may only run within the Volman container
    exit 1
fi

# Help dialog
help() {
    echo Copies the contents of one volume to another, overriding any existing data
    echo
    echo Use: $0 [source] [destination]
}

# Source/Destination
if [ -z "$1" ] || [ -z "$2" ]; then
    echo Please provide source/destination volumes
    help
    exit 1
elif [ "$1" = "$2" ]; then
    echo Please make sure the volumes are not identical
    exit 1
fi

# Execution context
cd /volman/volumes

# Check volumes
if [ ! -d "$1" ]; then
    echo "Volume '$1' does not exist"
    exit 1
elif [ ! -d "$2" ]; then
    echo "Volume '$2' does not exist"
    exit 1
fi

# Check if $2 is empty - prompt before overwrite
overwrite=Y
if [ -n "$(ls -A "$2")" ]; then
    echo "The '$2' volume is not empty, are you sure you'd like to overwrite its contents? This is irreversible! [y/N]"
    read overwrite
fi

# Overwrite contents
if [ "$overwrite" = "Y" ] || [ "$overwrite" = "y" ]; then
    echo "Overwriting '$2' as identical clone of '$1'"
    rm -rf "$2"/*
    cp -R "$1"/* "$2"
fi