# oscap-make-check-container
Runs openscap 'make distcheck' in a container. 
```sh
$ ./oscap-make-check-container.sh 
Usage:
./oscap-make-check-container.sh build|distcheck ...

   build DOCKER_IMG_NAME
     DOCKER_IMG_NAME is a new image which will be built based on
     Fedora image. All the dependencies for running openscap distcheck
     will be installed inside this image. Also distcheck.sh script
     will be copied into the /root directory inside the DOCKER_IMG_NAME
     image.
   distcheck DOCKER_IMG_NAME
     Runs a container from the DOCKER_IMG_NAME image and executes the
     /root/distcheck.sh script inside the container.
```

# Example usage
sudo is required because of docker:
```sh
$ sudo ./oscap-make-check-container.sh build oscap
$ sudo ./oscap-make-check-container.sh distcheck oscap
```
