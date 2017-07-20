#!/bin/bash

REQ_PACKAGES="openscap-containers docker atomic oci-systemd-hook oci-register-machine"

print_help() {
	echo -e "Usage:\n$0 build|test ...\n\n" \
	"  build DOCKER_IMG_NAME\n" \
	"    DOCKER_IMG_NAME is a new image which will be built based on\n" \
	"    Fedora image. All the dependencies for running openscap testing\n" \
	"    will be installed inside this image. Also the test.sh script\n" \
	"    will be copied into the /root directory inside the DOCKER_IMG_NAME\n" \
	"    image.\n" \
	"  test DOCKER_IMG_NAME\n" \
	"    Runs a container from the DOCKER_IMG_NAME image and executes the\n" \
	"    /root/test.sh script inside the container.\n"
}


if [ -z "$1" ] || [ "$1" = "help" ] || [ "$1" = "-h" ] || [ -z "$2" ]; then
	print_help
	exit 0
fi


if [ "$1" = "build" ]; then
	rpm -q $REQ_PACKAGES >/dev/null
	if [ $? -ne 0 ]; then
		echo "+++ Installing required packages.."
		dnf install -y $REQ_PACKAGES
	fi
	systemctl show docker | grep -iq "activestate=active" \
		|| systemctl start docker
	echo "+++ Building $2 container image.."
	docker build -t $2 .
elif [ "$1" = "test" ]; then
	echo "+++ Running $2 container image.."
	CONT=$(docker run -dt $2)
	CONT_SHORT_SHA=$(echo $CONT | cut -b 1-12)
	sleep 2
	echo "+++ Executing /root/test.sh script inside $CONT_SHORT_SHA container.."
	docker exec -t $CONT /root/test.sh
	docker rm -f $CONT
else
	print_help
	exit 1
fi
