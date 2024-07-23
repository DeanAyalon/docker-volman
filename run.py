import docker
client = docker.from_env()
print(client.containers.create('ubuntu:22.04', 'tail -f /dev/null').start())