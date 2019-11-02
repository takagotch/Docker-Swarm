docker run swarm create

docker-machine create \
	-d virtualbox \
	--swarm \
	--swarm-master \
	--swarm-discovery token://xxxx \
	master

docker-machine create \
	-d virtualbox \
	--swarm \
	--swarm-discovery token://xxx \
	node01

docker-machine create \
	-d virtualbox \
	--swarm-discovery token:/xxx \
	node02

docker-machine ls

eval "$(docker-machine env --shell bash --swarm master)"
set | grep DOCKER

docker info

docker run hello-world
docker run hello-world
docker run hello-world
docker ps -a
docker-machine ls
docker ps -a
docker logs xxx

