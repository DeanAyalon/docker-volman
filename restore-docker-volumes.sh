#!/bin/bash

# Execution context
cd $(dirname "$0")

# Check if the backup directory exists
if [ ! -d ./archive ]; then
    echo Backup directory not found: $PWD/archive
    exit 1
fi
cd archive

# Check if Docker daemon is running and get volumes
IFS=$'\n'
volumes=($(docker volume ls -q)) || exit 1
unset IFS

# Loop through each volume backup directory in the archive
for volume in *; do
    # Check if the volume already exists
    if [[ " ${volumes[@]} " =~ " ${volume} " ]]; then
        echo Volume $volume already exists. Skipping...
        continue
        # TODO Prompt to overwrite
    fi

    # Get the latest backup
    backup_file=$(ls -Art $volume | tail -n 1)
    echo Restoring backup for volume: $volume, backup file: $backup_file

    # Create a new volume with the extracted volume name
    docker volume create "$volume"

    # Restore the backup to the new volume
    docker run --rm -it \
    -v $volume:/restore -v ./$volume:/backup \
    alpine \
    tar xzvf /backup/"$backup_file" -C /restore
done