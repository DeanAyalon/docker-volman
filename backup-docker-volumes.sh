#!/bin/bash

# Execution context
cd "$(dirname "$0")"
# Create a directory for the backups if it doesn't exist
[ ! -d archive ] && mkdir archive
cd archive

# Get the list of docker volumes
volumes=$(docker volume ls -q) || exit 1

# Loop through each volume and create a backup
for volume in $volumes; do
    backup_date=$(date +"%Y%m%d_%H%M%S")
    backup_file="${volume}_$backup_date.tar.gz"
    echo Creating backup for volume: $volume, backup file: $backup_file

    volume_dir=./$volume
    [ ! -d "$volume_dir" ] && mkdir -p "$volume_dir"

    docker run --rm -it \
    -v $volume:/source -v $volume_dir:/backup \
    alpine \
    tar czvf /backup/$backup_file -C /source .
done
