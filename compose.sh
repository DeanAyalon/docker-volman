#!/bin/bash

# GET ALL DOCKER VOLUME NAMES -> $volumes
docker_volumes() {
    docker volume ls --format "{{.Name}}"
}
volumes=$(docker_volumes)

# Execution context
cd "$(dirname "$0")"

# Generate compose file
cp compose.base.yml compose.yml

# Container volumes
echo "volumes:" >> compose.yml

footer="volumes:"

for volume in $volumes; do
    echo "      - $volume:/volumes/$volume" >> compose.yml
    footer="$footer
      $volume:
        external: true" 
done

echo "
$footer" >> compose.yml

echo Generated compose file

# Compose container
docker compose up -d 