#!/bin/bash

# Create a directory for the backups if it doesn't exist
mkdir -p ${PWD}/archive

# Get the list of docker volumes
volumes=$(docker volume ls -q)

# Loop through each volume and create a backup
for source_volume in $volumes; do
  backup_date=$(date +"%Y%m%d_%H%M%S")
  backup_file="${source_volume}_${backup_date}.tar.gz"
  echo "Creating backup for volume: ${source_volume}, backup file: ${backup_file}"
  docker run --tty --rm --interactive --volume ${source_volume}:/source --volume ${PWD}/archive:/backup alpine tar czvf /backup/${backup_file} -C /source .
done
