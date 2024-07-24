#!python3

from typing import cast

import docker
from docker.models.containers import Container

client = docker.from_env()

# Define mounts by volume
volumes = client.volumes.list()
mounts = []
for volume in volumes: mounts.append(volume.name + ':/volman/volumes/' + volume.name)

# Start Volman
try: 
    volman = cast(Container, client.containers.run('ubuntu:22.04', ['tail', '-f', '/dev/null'], stderr = True, 
                                                    detach = True, volumes = mounts, name = 'volman', hostname = 'volman',
                                                    labels = { 'com.docker.compose.project': 'volman' }))
except Exception as e: print(e); exit()