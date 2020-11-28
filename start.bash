
docker run --rm -it -v ${PWD}/config:/etc/bind:ro --name=bind9 -p 53:53 -p 53:53/UDP bind9
