#!/bin/bash

# Execution context
workdir=$(pwd)
cd "$(dirname "$0")"
volmandir=$(pwd)

# Help dialog
help() {
    echo Use: $0 [options]
    echo Options:
    # echo "  -b      Add bind mount"
    echo "  -d      Remove Volman (Compose down)"
    echo "  -D      Forcefully remove Volman (rm -f)"
    echo "  -h      Show this Help dialog"
    echo "  -k      Keep Volman running after exit"
}

# GET ALL DOCKER VOLUME NAMES -> $volumes
docker_volumes() {
    docker volume ls --format "{{.Name}}"
}
volumes=$(docker_volumes) || exit 1

# Calculate full path from argument (absolute/relative)
# path() {
#     local path
#     # Empty argument
#     if [ ! -n "$1" ]; then
#         echo Empty path
#         exit 1
#     fi

#     # Absolute/relative path
#     if [[ "$1" == /* ]]; then
#         path="$1"
#     else
#         path="$workdir/$1"
#     fi

#     # Create dir if path does not exist
#     # [ ! -e "$path" ] && mkdir -p "$path"

#     echo $path
# }

# Environment
if [ ! -f .env ]; then
    cp template.env .env
    echo Edit this file to configure Docker Volman:
    echo "  $volmandir/.env"
fi
source .env
[ -z $IMAGE_SHELL ] && IMAGE_SHELL=sh

# Options
declare -a binds=()
while getopts "dDhk" opt; do
    case ${opt} in
        # b ) 
        #     echo $OPTARG
        #     bindpath=$(path "$OPTARG")
        #     bind="- $bindpath:/mounts/$(basename "$bindpath")"
        #     binds+=("$bind")
        #     ;;
        d ) down=true ;;
        D ) down=force ;;
        h ) help; exit 2 ;;
        k ) keep=true ;;
        ? ) help; exit 1 ;;
    esac
done

# Generate compose file
cp compose.base.yml compose.yml

# Compose down
if [ ! -z $down ]; then
    if [ "$down" = force ]; then
        docker rm -f volman
    else
        docker compose down
    fi
    exit 0
fi

# Add volumes
echo "volumes:" >> compose.yml

footer="volumes:"
for volume in $volumes; do
    echo "      - $volume:/volumes/$volume" >> compose.yml
    footer="$footer
      $volume:
        external: true" 
done

# TODO Add bind mounts

# Define external volumes
echo "
$footer" >> compose.yml

# Compose container
echo Generated compose file
docker compose up -d 

# Enter volume management and list available volumes
echo
echo "Entering volman - to exit, type 'exit'"
echo Available volumes:
docker exec -itu0 -w /volumes volman ls
docker exec -itu0 -w /volumes volman /bin/$IMAGE_SHELL

# Exit volman
# [ -z $keep ] && docker rm -f volman           # Fast
[ -z $keep ] && docker compose down           # Safer