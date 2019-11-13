# SnakeStrikeDocker
The build environment needed to create a docker image for the tracking code located in [SnakeStrike](https://github.com/gwjensen/SnakeStrike)

It includes all of the libraries that are needed. It also includes init files for these libraries so that they are built correctly and in the right order. The docker image is a multi-stage build to reduce the size of the final docker image. Since this was done without docker build-kit, you will need to manually delete one intermediate build step after the docker build completes. You will know which one it is as it will have "None" as a name.

## Requirements

1. 64 bit Linux - We don't support windows or 32 bit Linux.
2. Docker 
3. 70 GB free space ( if building manually )
   - This much space is needed as this docker build has very specific code dependencies. As such, these dependencies are hidden by building the dependencies from code stored in this repository. These means there are lots of build files that get generated. The docker build is set up as a multi-stage build, so the final image is as small as possible. That being said, the final image is still ~
11 GB in size. 
   - If you don't have this free space there is an already built docker image available for download [HERE](https://hub.docker.com/r/gwjensen/snake_strike).

## Building the image

1. Install docker on your system.

  - You can install docker by following the instructions here: [Install Docker-CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

2. Download this repository 
```bash
git clone https://github.com/gwjensen/SnakeStrikeDocker.git

``` 
3. Initiate all submodules
```bash
cd SnakeStrikeDocker
git submodule update --init
git submodule update

```

4. Build the docker image manually

```bash
docker build --tag=snake_strike_env --build-arg NUM_THREADS_FOR_BUILDS=7 .
```
   where NUM_THREADS_FOR_BUILDS is the number of passed to "make -j" commands. And don't forget the period at the end of the command!!!

5. Give Docker access to your xwindows so you can use the SnakeStrike gui.
```bash
sudo xhost +local:docker
```

6. Run SnakeStrike
```bash
docker run -ti  -v $HOME:'/home/tos'  -v '/dev/bus/usb':'/dev/bus/usb' --privileged -e DISPLAY=$DISPLAY  -v '/tmp/.X11-unix':'/tmp/.X11-unix' snake_strike_env SnakeStrike
```

## Don't want to build the image

If you don't have the space to build the image, but you still want to run SnakeStrike, you
can download the image [HERE](https://hub.docker.com/r/gwjensen/snake_strike).

You just install docker on your computer then run the following command:
```bash
docker pull gwjensen/snake_strike
```

The image will get pulled to your computer and you are ready to start using SnakeStrike!


## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Grady Jensen** - *Initial work* - [gwjensen](https://github.com/gwjensen)


## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details



### GPL3 LICENSE SYNOPSIS

**_TL;DR_*** Here's what the license entails:

```markdown
1. Anyone can copy, modify and distribute this software.
2. You have to include the license and copyright notice with each and every distribution.
3. You can use this software privately.
4. You can use this software for commercial purposes.
5. If you dare build your business solely from this code, you risk open-sourcing the whole code base.
6. If you modify it, you have to indicate changes made to the code.
7. Any modifications of this code base MUST be distributed with the same license, GPLv3.
8. This software is provided without warranty.
9. The software author or license can not be held liable for any damages inflicted by the software.
```

More information on about the [LICENSE can be found here](https://www.gnu.org/licenses/gpl-3.0.en.html)

