# Grady-TrackingOpenSource-docker
The build environment needed to create a docker image for the tracking code located in Grady-TrackingOpenSource

It includes all of the libraries that are needed. It also includes init files for these libraries so that they are built correctly and in the right order. The docker image is a multi-stage build to reduce the size of the final docker image. Since this was done without docker build-kit, you will need to manually delete one intermediate build step after the docker build completes. You will know which one it is as it will have "None" as a name.


To build this image.

1. Install docker on your system.
2. Download this repository ( git clone https://github.com/BRML/Grady-TrackingOpenSource-docker.git )
3. cd Grady-TrackingOpenSource-docker
4. git submdolue update --init
5. git submodules update
3. docker build --tag=smtracker --build-arg NUM_THREADS_FOR_BUILDS=7 .
   where NUM_THREADS_FOR_BUILDS is the number of passed to "make -j" commands.
4. sudo xhost +local:docker
5. docker run -ti  -v $HOME/Code/tos/:'/home/tos'  -v '/dev/bus/usb':'/dev/bus/usb' --privileged -e DISPLAY=$DISPLAY  -v '/tmp/.X11-unix':'/tmp/.X11-unix' smtracker /bin/bash


