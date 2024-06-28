#!/bin/bash

# Execution context
workdir=$(pwd)
cd "$(dirname "$0")"
volmandir=$(pwd)

# Help dialog
help() {
    echo Use: volman [options]
    echo Options:
    # echo "  -b      Add bind mount"
    echo "  -d      Stop Volman (Compose down)"
    echo "  -D      Forcefully stop Volman (rm -f)"
    echo "  -h      Show this Help dialog"
    echo "  -k      Keep Volman running after exit"
}

force_down() {
    docker rm -f volman
    docker network rm volman_default
}

volumes=$(docker volume ls -q) || exit 1
if [ -z "$volumes" ]; then
    echo "No Docker volumes found."
    exit 1
fi

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
        force_down
    else
        docker compose down
    fi
    exit 0
fi

# Add volumes
# echo "volumes:" >> compose.yml

footer="volumes:"
for volume in $volumes; do
    echo "      - $volume:/volman/volumes/$volume" >> compose.yml
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
echo "Entering volman"

echo
echo Available volumes:
docker exec -itu0 -w /volman/volumes volman ls

echo
echo Available scripts:
docker exec -itu0 -w /volman/scripts volman ls

# docker exec -itu0 -w /volman volman ls *            # I want to list subdirectory contents, but * translates to my host machine files

echo
echo To exit, type 'exit'

# Enter container
docker exec -itu0 -w /volman volman /bin/$IMAGE_SHELL

# Exit volman
[ -z $keep ] && docker compose down