#!/bin/bash

# Create a directory for the backups if it doesn't exist
backup_dir="$(dirname "$0")/archive"
# PWD will give the user's execution directory, not this repository
mkdir "$backup_dir"
# -p is unnecessary

# Get the list of docker volumes
volumes=$(docker volume ls -q)

# Loop through each volume and create a backup
for source_volume in $volumes; do
  backup_date=$(date +"%Y%m%d_%H%M%S")
  backup_file="${source_volume}_${backup_date}.tar.gz"
  echo "Creating backup for volume: ${source_volume}, backup file: ${backup_file}"
  docker run --tty --rm --interactive --volume ${source_volume}:/source --volume ${backup_dir}:/backup alpine tar czvf /backup/${backup_file} -C /source .
done
