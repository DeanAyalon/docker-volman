# Purpose
This repository was made to generate a dynamic container with all the existing named volumes as mounts - To allow for easy data management.

# Install
## Requirements
- Docker
- Docker Compose

## Command Alias
This tool is not yet available as a package, and so, it is currently most conveniently used with an alias in the user's RC files (`~/.zshrc`, `~/.bashrc`, etc.)
```sh
alias volman=path/to/this/repository/run.sh
```

# Use
## Run
Simply use the `run.sh` script, it will generate a compose file based on the existing volumes, create the container, and enter into the volumes directory.

## Configuration
Use a `.env` file (See [template.env](./template.env)) to use a custom image and shell language for Volman.
> You may also add `COMPOSE_PROJECT_NAME` to set a Docker project name instead of 'volman'

## Options
Use `run.sh -h` to list available command options

# Featured Technologies
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/DeanAyalon/verdaccio/pkgs/container/verdaccio)
![Shell](https://img.shields.io/badge/shell-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)


# Future
I may in the future customize this some more to allow:
- Volume selection 
- Permission management
- Some sort of GUI
- Other volume tweaks and scripts
- Dynamic volume assignment ([docker-gen](https://github.com/nginx-proxy/docker-gen)?)

But currently, this suits me just fine, all I need is to access the files within all my volumes