# Purpose
This repository was made to generate a dynamic container with all the existing named volumes as mounts - To allow for easy data management.

# Requirements
- Docker
- Docker Compose

# Use
## Run
Simply use the `run.sh` script, it will generate a compose file based on the existing volumes, create the container, and enter into the volumes directory.

# Featured Technologies
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://github.com/DeanAyalon/verdaccio/pkgs/container/verdaccio)
![Shell](https://img.shields.io/badge/shell-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

# Credit
Backup scripts initial state made by [rickarddahlstrand](https://github.com/rickarddahlstrand) - [Source](https://github.com/rickarddahlstrand/backup-restore-docker-volumes)

# Future
I may in the future customize this some more to allow:
- Backups
- Volume selection 
- Permission management
- Some sort of GUI
- Other volume tweaks and scripts
- Dynamic volume assignment ([docker-gen](https://github.com/nginx-proxy/docker-gen)?)

But currently, this suits me just fine, all I need is to access the files within all my volumes

# Git Remotes
- Volman: `https://github.com/DeanAyalon/docker-volman`
- Backups: `https://github.com/DeanAyalon/backup-restore-docker-volumes`
- Backups/upstream: `https://github.com/rickarddahlstrand/backup-restore-docker-volumes`