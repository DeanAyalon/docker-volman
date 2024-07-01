#!/bin/bash

# Help dialog
help() {
    echo Use: volman [options]
    echo Creates a container with all named volumes mounted to it, for easy management.
    echo
    echo Options:
    # echo "  -b      Add bind mount"
    echo "  -d      Stop Volman (Compose down)"
    echo "  -D      Forcefully stop Volman (rm -f)"
    echo "  -e      Enter a running Volman container"
    echo "  -h      Show this Help dialog"
    echo "  -k      Keep Volman running after exit"
    echo 
    echo Consult $volmandir for further information
}

compose_volman() {
    # Generate compose file
    cp compose.base.yml compose.yml

    # Add volumes
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
    echo
}

# Enter running volman
enter_container() {
    # Check container
    docker exec -itu0 volman pwd > /dev/null || exit 1

    echo "Entering volman"

    # List volumes and scripts
    echo
    echo Available volumes:
    docker exec -itu0 -w /volman/volumes volman ls
    echo
    echo Available scripts:
    docker exec -itu0 -w /volman/scripts volman ls
    echo
    echo To exit, type 'exit'

    docker exec -itu0 -w /volman volman /bin/$IMAGE_SHELL
}

# Stop Volman
take_down() {
    echo "Taking Volman down, if this process takes too long, use 'volman -D' to force it to exit"
    docker compose down
}
force_down() {
    docker rm -f volman
    # ONLY REMOVE THE NETWORK IF THE PROJECT IS EMPTY
    # docker network rm ${project}_default
}

# SCRIPT EXECUTION

# Execution context
cd "$(dirname "$0")"
volmandir=$(pwd)

# Get existing volumes
volumes=$(docker volume ls -q) || exit 1
if [ -z "$volumes" ]; then
    echo No Docker volumes found.
    exit 1
fi

# Environment
if [ ! -f .env ]; then
    cp template.env .env
    echo Edit this file to configure Docker Volman:
    echo "  $volmandir/.env"
fi
source .env

[ -z $IMAGE_SHELL ] && IMAGE_SHELL=sh

# Compose project - if set in .env
project=volman
[ ! -z $COMPOSE_PROJECT_NAME ] && project=$COMPOSE_PROJECT_NAME

# Options
declare -a binds=()
while getopts "dDehk" opt; do
    case ${opt} in
        # b ) 
        #     echo $OPTARG
        #     bindpath=$(path "$OPTARG")
        #     bind="- $bindpath:/mounts/$(basename "$bindpath")"
        #     binds+=("$bind")
        #     ;;

        # Add options that would define override.env?

        d ) take_down ; exit 0 ;;
        e ) keep=true; generate=false ;;
        D ) force_down ; exit 0 ;;
        h ) help; exit 2 ;;
        k ) keep=true ;;
        ? ) help; exit 1 ;;
    esac
done
shift "$((OPTIND-1))"

[[ $generate != "false" ]] && compose_volman

# Enter container
enter_container

# Exit volman
if [ -z $keep ]; then
    take_down
else
    echo "To take volman down, use 'volman -d'"
    echo "To enter volman without recreating it, do 'volman -e'"
fi