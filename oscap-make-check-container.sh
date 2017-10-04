#!/bin/bash

REQ_PACKAGES="openscap-containers docker atomic oci-systemd-hook oci-register-machine"

print_help() {
	echo -e "Usage:\n$0 build|distcheck ...\n\n" \
	"  build DOCKER_IMG_NAME\n" \
	"    DOCKER_IMG_NAME is a new image which will be built based on\n" \
	"    Fedora image. All the dependencies for running openscap distcheck\n" \
	"    will be installed inside this image. Also distcheck.sh script\n" \
	"    will be copied into the /root directory inside the DOCKER_IMG_NAME\n" \
	"    image.\n" \
	"  distcheck DOCKER_IMG_NAME\n" \
	"    Runs a container from the DOCKER_IMG_NAME image and executes the\n" \
	"    /root/distcheck.sh script inside the container.\n"
}

check_requirements() {
	# Makes sure that required packages are installed and docker is running.
	rpm -q $REQ_PACKAGES >/dev/null
	if [ $? -ne 0 ]; then
		echo "Error: Required packages are missing" 1>&2
		echo -e "This script requires:\n$REQ_PACKAGES" 1>&2
		exit 1
	fi
	systemctl show docker | grep -iq "activestate=active"
	if [ $? -ne 0 ]; then
		echo "Error: docker service is not running" 1>&2
		exit 1
	fi
}


if [ -z "$1" ] || [ "$1" = "help" ] || [ "$1" = "-h" ] || [ -z "$2" ]; then
	print_help
	exit 0
fi
check_requirements


if [ "$1" = "build" ]; then
	if [ ! -f "Dockerfile" ]; then
		echo "Error: No Dockerfile found in $(pwd)" 1>&2
		exit 1
	fi
	if [ ! -f "distcheck.sh" ]; then
		echo "Error: No distcheck.sh found in $(pwd)" 1>&2
		exit 1
	fi
	echo "---> Building $2 container image"
	docker build -t $2 .
elif [ "$1" = "distcheck" ]; then
	echo "---> Running $2 container image"
	#TODO: remove --privileged as soon as the bug with container-selinux is
	# resolved: https://bugzilla.redhat.com/show_bug.cgi?id=1477138
	CONT=$(docker run -dt --privileged $2)
	CONT_SHORT_SHA=$(echo $CONT | cut -b 1-12)
	sleep 2
	echo "---> Executing /root/distcheck.sh inside $CONT_SHORT_SHA container"
	docker exec -t $CONT \
		bash -c "/root/distcheck.sh 2>&1 | tee /root/distcheck.log"
	echo "---> To see log from distcheck in $CONT_SHORT_SHA container run:"
	echo "---> docker exec -it $CONT_SHORT_SHA vim /root/distcheck.log"
else
	print_help
	exit 1
fi
