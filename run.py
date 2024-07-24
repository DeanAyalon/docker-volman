#!python3

from typing import cast
import os
import subprocess

import docker
from docker.models.containers import Container

client = docker.from_env()

# Environment variables (.env)
image = os.environ.get('IMAGE') if 'IMAGE' in os.environ else 'alpine'
shell = os.environ.get('IMAGE_SHELL') if 'IMAGE_SHELL' in os.environ else 'sh'

# Define mounts by volume
volumes = client.volumes.list()
mounts = []
for volume in volumes: mounts.append(volume.name + ':/volman/volumes/' + volume.short_id)

# Stop volman if running
try: 
    volman = client.containers.get('volman')
    volman.remove(force = True)
except Exception as e: {}

# Start Volman
try: volman = cast(Container, client.containers.run(image, ['tail', '-f', '/dev/null'], stderr = True, 
                                                    detach = True, volumes = mounts, name = 'volman', hostname = 'volman',
                                                    labels = { 'com.docker.compose.project': 'volman' }))
except Exception as e: print(e); exit()

# Print
print('Entering Volman\n')

print('Available volumes:')
for volume in volumes: print(volume.short_id)

print('\nTo exit, type exit')

# Enter Volman
subprocess.Popen(['docker', 'exec', '-itw', '/volman', 'volman', '/bin/' + shell]).wait()
# volman.exec_run('/bin/sh', stdin=True, tty=True)  # TODO implement with Docker Python SDK

# Remove Volman
volman.remove(force = True)