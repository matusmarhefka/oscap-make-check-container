# oscap-make-check-container
 Run openscap 'make check' in a container. 
```sh
$ ./oscap-make-check-container.sh 
Usage:
./oscap-make-check-container.sh build|test ...

   build DOCKER_IMG_NAME
     DOCKER_IMG_NAME is a new image which will be built based on
     Fedora image. All the dependencies for running openscap testing
     will be installed inside this image. Also the test.sh script
     will be copied into the /root directory inside the DOCKER_IMG_NAME
     image.
   test DOCKER_IMG_NAME
     Runs a container from the DOCKER_IMG_NAME image and executes the
     /root/test.sh script inside the container.
```

# Example usage
```sh
$ ./oscap-make-check-container.sh build openscap
$ ./oscap-make-check-container.sh test openscap
```
