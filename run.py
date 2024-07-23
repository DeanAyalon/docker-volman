#!python3

import docker
client = docker.from_env()

# Define mounts by volume
volumes = client.volumes.list()
mounts = []
for volume in volumes: mounts.append(volume.name + ':/volman/volumes/' + volume.name)

# Start Volman
volman = client.containers.run('ubuntu:22.04', ['tail', '-f', '/dev/null'], stderr = True, 
                               detach = True, volumes = mounts, name = 'volman', hostname = 'volman',
                               labels = { 'com.docker.compose.project': 'volman' })