# Docker Howtos

> NOTE: The host and the containers in the howto guide will focus on on the Centos 7 operating system.

## Install Docker

    sudo yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2

    sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    sudo yum install docker-ce

    sudo systemctl enable docker

    sudo systemctl start docker

At this point you should be able to run:

    sudo docker run hello-world

## Make your life easier

Add a docker group and add all users that should be able to interact with Docker.  This will allow these users to use docker without a sudo command.

    sudo groupadd docker

    sudo usermod -a -G groupadd user

Changes will only take effect after a re-login.

> NOTE:  The docker group should be considered the same level access as a system admin.

## Getting Started

### Building an Image

First construct a Dockerfile:

    FROM centos
    EXPOSE 8080
    RUN mkdir -p /opt/http
    WORKDIR "/opt/http"
    CMD [ "python", "-m", "SimpleHTTPServer", "8080" ]


### Running the Image

    $ docker run -d --rm -P -v $PWD/:/opt/http simplehttp
    69d63580eb4ed7284df63bb30190727fa8295e8b4fe00a49000f97b338d340a4

The container id is returned after starting the container.

### Listing Running Containers

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                     NAMES
    69d63580eb4e        simplehttp          "python -m SimpleHTT…"   3 seconds ago       Up 2 seconds        0.0.0.0:32769->8080/tcp   awesome_hermann

> NOTE: The exposed port is not 8080 it is dynamically allowed to 32769 for this container.

## Docker Volumes

Docker provides volumes as a way of both injecting runtime data into the container as well as persisting data between instances of the container.

### Anonymous Volumes

Inside a Dockerfile the VOLUME keyword is used to define anonymous volumes.  Anonymous volumes lifecycles parallel the lifecycle of the container when it's created and destroyed.  The volume remains when the container is stopped and started again.

    FROM centos
    VOLUME "/test"

### Local Volumes

Creating a local volume:

    docker volume create testvolume

Using a local volume:

    docker run -it --rm -v testvolume:/test-mnt centos bash

### 3rd Party Volume Plugins

- Flocker
- DBRD
- Infinit

And many others.

## Networking

### Docker Bridge

The default networking option for docker that allows for a NAT to the host network.  The publish options on the docker run command allow you to map the container's internal ports to external host ports.

This example exposes all internal ports to random open ports on the host:

    docker run --name test -d --rm -P -v $PWD/:/opt/http simplehttp

If you want to use known host port mappings:

    docker run --name test -d --rm -p 5000:8080 -v $PWD/:/opt/http simplehttp

If you want to use known host ip address and port mappings:

    docker run --name test -d --rm -p 127.0.0.1:5000:8080 -v $PWD/:/opt/http simplehttp

### Docker Overlay

This networking features requires an external key value store or swarm.

#### Regular Setup

    mkdir -p /etc/docker
    cat >/etc/docker/daemon.json <<EOF
    {
     "cluster-advertise":"enp0s8:2765",
     "cluster-store":"zk://192.168.56.1/docker"
    }
    EOF

#### Create Overlay Network

    docker network create -d overlay testnetwork

#### Using Overlay Network

    docker run --name test -d --rm --net testnetwork -v $PWD/:/opt/http simplehttp

Now that you have your web server running how you access it from within the overlay network.

    docker run --name test -d --rm -v $PWD/:/opt/http simplehttp
    docker network connect testnetwork




## Docker Logs




Base Images:

Install inline or script (layers)
Entrypoints and commands (tini systemd)
Health check scripts
Anonymous volumes

Running

Running restart always attached or deattahced
Capabilities
Logs
