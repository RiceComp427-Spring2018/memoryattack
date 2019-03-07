exited-containers:=`sudo docker ps -qa --no-trunc --filter "status=exited"`
build: dockerbuild
pwd=`pwd`

dockerbuild: Dockerfile
	sudo docker build -t 427hax .

launch-container:
	sudo docker run --privileged -v $(pwd):/427hax-mnt -it 427hax /bin/bash

attacks:
	$(MAKE) -C stacksmash

getenv: getenvaddr/getenvaddr.c
	cd getenvaddr && gcc getenvaddr.c -o getenvaddr

clean-containers:
	echo "Removing all exited containers..."
	sudo docker rm $(exited-containers)
