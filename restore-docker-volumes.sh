#!/bin/bash

# Directory containing the backup files
backup_dir="${PWD}/archive"

# Check if the backup directory exists
if [ ! -d "$backup_dir" ]; then
  echo "Backup directory not found: $backup_dir"
  exit 1
fi

# Loop through each backup file in the directory
for backup_file in "$backup_dir"/*.tar.gz; do
  # Extract the volume name from the backup file name
  base_name=$(basename "$backup_file")
  volume_name=$(echo "$base_name" | sed -E 's/(.+)_[0-9]{8}_[0-9]{6}\.tar\.gz/\1/')
  
  # Check if the volume already exists
  if docker volume ls -q | grep -q "^${volume_name}$"; then
    echo "Volume ${volume_name} already exists. Skipping..."
  else
    echo "Restoring backup for volume: ${volume_name}, backup file: ${backup_file}"

    # Create a new volume with the extracted volume name
    docker volume create "${volume_name}"

    # Restore the backup to the new volume
    docker run --rm --interactive --tty --volume ${volume_name}:/restore --volume ${backup_dir}:/backup alpine tar xzvf /backup/"${base_name}" -C /restore
  fi
done
