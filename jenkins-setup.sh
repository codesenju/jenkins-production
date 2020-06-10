#!/bin/bash
docker network create jenkins
#Create the following volumes to share the Docker client TLS certificates needed to connect to the Docker daemon and persist the Jenkins data using the following docker volume create commands:
docker volume create jenkins-docker-certs
docker volume create jenkins-data

#In order to execute Docker commands inside Jenkins nodes, download and run the docker:dind Docker image using the following docker container run command:
docker container run --name jenkins-docker --rm -d --privileged --network jenkins --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client -v //home/codesenju/jenkins_home/:/var/jenkins_home --volume //home/codesenju/jenkins_home/:/home -p 3000:3000 docker:dind

# 	Maps the /var/jenkins_home directory in the container to the Docker volume with the name jenkins-data. If this volume does not exist, then this docker container run command will automatically create the volume for you.
#	Maps the $HOME directory on the host (i.e. your local) machine (usually the /Users/<your-username> directory) to the /home directory in the container.
docker run --name jenkins-server --rm -d --network jenkins -e DOCKER_HOST=tcp://docker:2376 -e DOCKER_CERT_PATH=/certs/client -e DOCKER_TLS_VERIFY=1 -v //home/codesenju/jenkins_home:/var/jenkins_home -v jenkins-docker-certs:/certs/client:ro -v //home/codesenju/jenkins_home:/home -p 9090:8080 jenkinsci/blueocean
