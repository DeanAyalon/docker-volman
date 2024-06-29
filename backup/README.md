# About
These scripts were forked from [rickarddahlstrand/backup-restore-docker-volumes](https://github.com/rickarddahlstrand/backup-restore-docker-volumes)

# Status
Not yet ready for Docker Volman, will undergo further modifications before being added to the scripts directory
## TODO
- [ ] Fix functionality for multiple backup files of the same volume
    - Choose latest by default, allow listing and selecting backup
    - Folder architechture: `./backups/<volume>/<volume>_<date>.tar.gz`
- [ ] Add options to the scripts
    - [ ] `-a` All volumes
    - [ ] `-n` Backup file name
    - [ ] Restore: `-d <timestamp>` (yyyymmdd)
    - [ ] `-l <path>` Backup location
- [ ] Add backup location to `.env`
- [ ] Optional: Add zip or other compression methods 
- [ ] Add automated tasks

## Alternative
Check out [offen/docker-volume-backup](https://github.com/offen/docker-volume-backup)
