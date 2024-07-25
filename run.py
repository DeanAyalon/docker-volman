#!python3

from typing import cast
import os               # Environment variables
import argparse    # Script arguments
import subprocess       # Shell commands

import docker
from docker.models.containers import Container

# Functions
def stop(volman = None):
    try: 
        if volman is None: volman = client.containers.get('volman')
        volman.remove(force = True)
    except Exception as e: {} # Container not found

def start():
    try: return cast(Container, client.containers.run(image, ['tail', '-f', '/dev/null'], stderr = True, 
                                                        detach = True, volumes = mounts, name = 'volman', hostname = 'volman',
                                                        labels = { 'com.docker.compose.project': 'volman' }))
    except Exception as e: print('Error starting Volman', e); exit(1)

# TODO implement with Docker Python SDK
def enter(): subprocess.Popen(['docker', 'exec', '-itw', '/volman', 'volman', '/bin/' + shell]).wait()
                        # volman.exec_run('/bin/sh', stdin=True, tty=True)  

# SCRIPT EXECUTION

# Script arguments
parser = argparse.ArgumentParser()
parser.description = 'Creates a Docker container mounted to all existing volumes, for easy management'
parser.add_argument('-d', '--down', help='Take an existing Volman container down', action=argparse.BooleanOptionalAction)
parser.add_argument('-e', '--enter', help='Enter an existing Volman container', action=argparse.BooleanOptionalAction)
parser.add_argument('-i', '--image', help='Specify a custom image for Volman to be built on. To set as default, use .env')
parser.add_argument('-k', '--keep', help='Keep the container running after exiting the interactive shell', action=argparse.BooleanOptionalAction)
args = parser.parse_args()

# Environment variables (.env)
image = args.image if args.image != None else os.environ.get('IMAGE') if 'IMAGE' in os.environ else 'alpine'
shell = os.environ.get('IMAGE_SHELL') if 'IMAGE_SHELL' in os.environ else 'sh'

# -e/--enter: Enter Volman
if args.enter: enter(); exit()

# Initialize DockerClient
client = docker.from_env()

# -d/--down: Stop Volman
if args.down: stop(); exit()

# Define mounts by volume
volumes = client.volumes.list()
mounts = []
for volume in volumes: mounts.append(volume.name + ':/volman/volumes/' + volume.short_id)

# Stop running Volman
stop()

# Start Volman
volman = start()

# Print
print('Entering Volman\n')

print('Available volumes:')
for volume in volumes: print(volume.short_id)

print('\nTo exit, type exit')

# Enter Volman
enter()

# Stop Volman
if not args.keep: stop(volman)