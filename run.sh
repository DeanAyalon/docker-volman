#!/bin/bash

# GET ALL DOCKER VOLUME NAMES -> $volumes
docker_volumes() {
    docker volume ls --format "{{.Name}}"
}
volumes=$(docker_volumes)

# Execution context
cd "$(dirname "$0")"
workdir=$(pwd)

# Environment

if [ ! -f .env ]; then
    cp template.env .env
    echo Edit this file to configure Docker Volman:
    echo "  $workdir/.env"
fi
source .env
[ -z $IMAGE_SHELL ] && IMAGE_SHELL=sh

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

# Enter volume management and list available volumes
echo
echo "Entering volman - to exit, type 'exit'"
echo Available volumes:
docker exec -itu0 -w /volumes volman ls
docker exec -itu0 -w /volumes volman /bin/$IMAGE_SHELL