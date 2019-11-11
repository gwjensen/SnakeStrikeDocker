#####################################################################################################################################
#####################################################################################################################################

FROM ubuntu:16.04 as base-smt-build
LABEL   description="A container that takes care of all the dependencies required to run SnakeStrike." \
	maintainer="Grady Jensen <grady.jensen@brml.org>" \
	version="1.0.0" 
ARG NUM_THREADS_FOR_BUILDS=2
ENV THREADS_FOR_BUILDS=${NUM_THREADS_FOR_BUILDS}

COPY env_setup.sh /home


###################################################################
# Configure 3rd-party apt repos, add foreign arches, and update OS

# update OS
RUN apt-get update && \
    apt-get -y upgrade

###################################################################
# Install generic packages

RUN apt-get update && apt-get -y install \
		apt-utils \
		apt-transport-https \
		build-essential \
		linux-libc-dev \
	      	libusb-1.0-0-dev \
	 	libusb-dev \
		libudev-dev \
		libblas-dev \
		liblapack-dev \
		gfortran \
		libgtk2.0-dev \
		pkg-config \
		gconf2


###############################################
# Utilities
RUN apt-get -y install \
	locales \
	git \
      	cmake \
	cmake-gui \
	sharutils \
	net-tools \
	time \
	xvfb \
	xauth \
	wget \
        sudo \
	usbutils \
	module-init-tools	 

################################################
### Install Dependencies for Qt 5 
RUN apt-get update && apt-get -y install \
			bison \ 
			build-essential \
			flex \
			gperf \
			ibgstreamer-plugins-base0.10-dev \
			libasound2-dev \
			libatkmm-1.6-dev \
			libbz2-dev \
			libcap-dev\
			libcups2-dev  \
			libdrm-dev \
			libfontconfig1-dev \
			libfreetype6-dev \
			libgcrypt11-dev  \
			libgstreamer0.10-dev \
			libicu-dev \
			libnss3-dev \
			libpci-dev  \
			libpulse-dev \
			libssl-dev \
			libudev-dev \
			libx11-dev \
			libx11-xcb-dev \
		 	libxcb-composite0 \
			libxcb-composite0-dev \
			libxcb-cursor-dev \
			libxcb-cursor0 \
			libxcb-damage0 \
			libxcb-dpms0 \
			libxcb-dri2-0 \
			libxcb-dri3-0 \
			libxcb-ewmh-dev \
			libxcb-ewmh2 \
			libxcb-glx0 \
			libxcb-present-dev \
			libxcb-present0 \
			libxcb-record0 \
			libxcb-render0 \
			libxcb-res0 \
			libxcb-screensaver0 \
			libxcb-sync-dev \
			libxcb-sync1 \
			libxcb-util-dev \
			libxcb-util0-dev \
			libxcb-util1 \
			libxcb-xevie0 \
			libxcb-xf86dri0 \
			libxcb-xinerama0 \
			libxcb-xkb-dev \
			libxcb-xkb1 \
			libxcb-xprint0 \
			libxcb-xtest0 \
			libxcb-xv0 \
			libxcb-xvmc0 \
			libxcb1 \
			libxcb1-dev \
			libxcursor-dev \
			libxdamage-dev \
			libxext-dev \
			libxfixes-dev \
			libxi-dev \
			libxrandr-dev \
			libxrender-dev \
			libxslt-dev \
			libxss-dev \
			libxtst-dev \
			perl \
			python \
			ruby \
			libxkbcommon-x11-dev 

###############################################
#PCL Requirements
RUN apt-get -y install \
      	mpi-default-dev \
	openmpi-bin \
	openmpi-common  \
      	libflann1.8 \
	libflann-dev \
	libeigen3-dev \
      	libboost-all-dev \
      	libvtk5.10-qt4 \
	libvtk5.10 \
	libvtk5-dev \
      	libqhull* \
	libgtest-dev \
      	freeglut3-dev \
	pkg-config \
      	libxmu-dev \
	libxi-dev \ 
      	mono-complete \
      	qt-sdk \
	openjdk-8-jdk \
	openjdk-8-jre

###############################################
#OpenMVG Requirements
RUN apt-get -y install \
	xorg-dev 

###############################################
#OpenMVS Requirements
RUN apt-get -y install \
	libgmp3-dev \
	libmpfr-dev \
	libmpfr-doc 

###############################################
#OpenCV Requirements
RUN apt-get -y install \
        ffmpeg

###############################################
# Documentation
RUN apt-get -y install \
	graphviz \
	doxygen \
	doxygen-gui


###########################################
# Set up environment
#
# Customize the following to match the user's environment

# Set up user ID inside container to match your ID
ENV USER tos
ENV UID 1000
ENV GID 1000
ENV HOME /home/${USER}
ENV SHELL /bin/bash
ENV QT_QPA_PLATFORM_PLUGIN_PATH=/opt/Qt/5.13.0/gcc_64/plugins/platforms/
ENV QT5_DIR=/opt/Qt/5.13.0/gcc_64/lib/cmake/

ENV PATH /opt/Qt/5.13.0/gcc_64/lib/:/opt/Qt/5.13.0/gcc_64/bin/:/opt/Qt/5.13.0/gcc_64/include:$QT5_DIR:/usr/lib/ccache:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin:/usr/lib/x86_64-linux-gnu/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/usr/local/lib:/opt/pylon5/lib64:/usr/local/cuda-9.1/bin:/usr/local/cuda-9.1/lib64:/usr/local/cuda-9.1/include:/usr/local/cuda-9.1/nvvm/lib64:/opt/:/opt/vcg:/opt/vcg/vcg:/opt/tos/bin:/opt/pylon5/bin:/opt/pylon5/include:

ENV LD_LIBRARY_PATH=/usr/local/lib:/opt/Qt/5.13.0/gcc_64/lib:/opt/Qt/5.13.0/gcc_64/lib/cmake:$LD_LIBRARY_PATH:/opt/pylon5/lib64:/opt/pylon5/bin:/usr/local/cuda-9.1/:/usr/local/cuda-9.1/lib64:/usr/local/cuda-9.1/nvvm/lib64:/opt/tos/lib:


RUN echo "${USER}:x:${UID}:${GID}::${HOME}:${SHELL}" >> /etc/passwd
RUN echo "${USER}:x:${GID}:" >> /etc/group
RUN mkdir -p ${HOME} && chown $USER:$USER ${HOME} && chown $USER:$USER "/home/env_setup.sh"

# More proxy config for git
ENV http_proxy $HTTP_PROXY
ENV https_proxy $HTTP_PROXY

# Customize the run environment to your taste
# - bash prompt
# - 'ls' alias
RUN sed -i /etc/bash.bashrc \
    -e 's/^PS1=.*/PS1="\\h:\\W\\$ "/' \
    -e '$a alias ls="ls -aFs"'

# Configure sudo, passwordless for everyone
RUN echo "ALL	ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

WORKDIR ${HOME}
RUN mkdir -p "${HOME}/Libraries"


###############################################
# Install intel mkl library
RUN 	cd /tmp && \
	wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
	apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB && \
	sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list' && \
	apt-get update && \
	apt-get -y install intel-mkl-64bit-2018.2-046 && \
	cd $WORKDIR


###############################################
# Install Cuda 9.0 

#ENV DEBIAN_FRONTEND noninteractive
#COPY	./Libraries/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb "${HOME}/Libraries/cuda-repo-#ubuntu1604_9.0.176-1_amd64.deb" 
#RUN 	dpkg -i "${HOME}/Libraries/cuda-repo-ubuntu1604_9.0.176-1_amd64.deb" && \
#	apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/#x86_64/7fa2af80.pub && \
#	apt-get update && \
#	apt-get -y install --no-install-recommends cuda


##########################################################################################################################################
##########################################################################################################################################
## We have this small build here because the QT build takes Foreeevvvveerrrr.....
FROM base-smt-build as build-workspace-base 

################################################
### Install Qt 5 - Can't call make with multiple threads because the build is 
###  configured in such a way that it won't build correctly. I.e. they didn't use cmake.
###
RUN cd /tmp && wget http://download.qt.io/official_releases/qt/5.13/5.13.0/single/qt-everywhere-src-5.13.0.tar.xz

RUN cd /tmp && tar -xf /tmp/qt-everywhere-src-5.13.0.tar.xz 

RUN cd "/tmp/qt-everywhere-src-5.13.0" && \
#    sh -c '/bin/echo -e "o\ny\n" | /tmp/qt-everywhere-src-5.13.0/configure -prefix /tmp/qt-everywhere-src-5.13.0/qtbase -opensource -confirm-license -release -nomake tests -nomake examples' && \
    /tmp/qt-everywhere-src-5.13.0/configure -v -platform linux-g++ -prefix /opt/Qt/5.13.0/gcc_64/ -opensource -c++std c++11 -confirm-license -release -nomake tests -nomake examples -skip qtwayland -skip qtlocation -skip qtactiveqt -skip qtandroidextras -skip qtcharts -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtsensors -skip qtspeech -skip qtsvg -skip qttranslations -skip qtvirtualkeyboard -skip qtwebchannel -skip qtwebengine -skip qtwebglplugin -skip qtwebsockets -skip qtwebview -skip qtwinextras -skip qtimageformats -skip qtgraphicaleffects -skip qtdeclarative  -skip qtremoteobjects -skip qtconnectivity -skip qtxmlpatterns -qt-xcb && \
    make -j ${NUM_THREADS_FOR_BUILDS}
RUN cd "/tmp/qt-everywhere-src-5.13.0" && \
    make install

#RUN rm -rf /opt/Qt/* && \
#    mkdir -p /opt/Qt/5.13.0/gcc_64 && \
#    mv /usr/local/Qt-5.13.0/* /opt/Qt/5.13.0/gcc_64/ 



##########################################################################################################################################
##########################################################################################################################################
FROM build-workspace-base as build-workspace

##############################################
## Move over the libraries we need to build and the scripts we need
COPY ./Libraries $HOME/Libraries

###############################################
# Install Pylon 5

RUN	mkdir -p /etc/udev/rules.d
RUN 	tar -C /opt -xzf "${HOME}/Libraries/pylon5/pylonSDK-5.2.0.13457-x86_64.tar.gz" 
RUN 	sh -c '/bin/echo -e "yes\n" | "${HOME}/Libraries/pylon5/setup-usb.sh"'

###############################################
# Install Eigen
#
RUN	mkdir "${HOME}/Libraries/eigen_build" && \
	cd "${HOME}/Libraries/eigen_build" && \
	cmake -C "${HOME}/Libraries/eigen-cmake-init.txt" "${HOME}/Libraries/eigen_build" "${HOME}/Libraries/eigen-3.3.4" && \
	make -C "${HOME}/Libraries/eigen_build"	install -j ${THREADS_FOR_BUILDS}

###############################################
# Install gflags
#
RUN	mkdir "${HOME}/Libraries/gflags_build" && \
	cd "${HOME}/Libraries/gflags_build" && \
	cmake -C "${HOME}/Libraries/gflags-cmake-init.txt" "${HOME}/Libraries/gflags_build" "${HOME}/Libraries/gflags-2.2.1" && \
	make -C "${HOME}/Libraries/gflags_build" install -j ${THREADS_FOR_BUILDS}

###############################################
# Install glog
#
RUN	mkdir "${HOME}/Libraries/glog_build" && \
	cd "${HOME}/Libraries/glog_build" && \
	cmake -C "${HOME}/Libraries/glog-cmake-init.txt" "${HOME}/Libraries/glog_build" "${HOME}/Libraries/glog-0.3.5" && \
	make -C "${HOME}/Libraries/glog_build" install -j ${THREADS_FOR_BUILDS}

###############################################
# Install ceres
#
RUN	mkdir "${HOME}/Libraries/ceres_build" && \
	cd  "${HOME}/Libraries/ceres_build" && \
	cmake -C "${HOME}/Libraries/ceres-cmake-init.txt" "${HOME}/Libraries/ceres_build" "${HOME}/Libraries/ceres-solver-1.13.0" && \
	make -C "${HOME}/Libraries/ceres_build"	install -j ${THREADS_FOR_BUILDS}

###############################################
# Install vtk
RUN	mkdir "${HOME}/Libraries/vtk_build" && \
	cd "${HOME}/Libraries/vtk_build" && \
	cmake -C "${HOME}/Libraries/vtk-cmake-init.txt" "${HOME}/Libraries/vtk_build" "${HOME}/Libraries/VTK-8.0.1" && \
	make -C "${HOME}/Libraries/vtk_build" install -j ${THREADS_FOR_BUILDS}

###############################################
# Install opencv and its contributed modules
RUN	mkdir "${HOME}/Libraries/opencv_build" && \
	cd "${HOME}/Libraries/opencv_build" && \
	cmake -C "${HOME}/Libraries/opencv-cmake-init.txt" "${HOME}/Libraries/opencv_build" "${HOME}/Libraries/opencv-3.4.0" && \
	make -C "${HOME}/Libraries/opencv_build" install -j ${THREADS_FOR_BUILDS}


###############################################
# Install openMVG
#
RUN	mkdir "${HOME}/Libraries/openmvg_build" && \
	cd "${HOME}/Libraries/openmvg_build" && \
	cmake -C "${HOME}/Libraries/openmvg-cmake-init.txt" "${HOME}/Libraries/openmvg_build" "${HOME}/Libraries/openMVG-1.3/src/openMVG/src" && \
	make -C "${HOME}/Libraries/openmvg_build" install -j ${THREADS_FOR_BUILDS}

###############################################
# Install CGAL - required by openMVS
#
RUN	mkdir "${HOME}/Libraries/cgal_build" && \
	cd "${HOME}/Libraries/cgal_build" && \
	cmake -C "${HOME}/Libraries/cgal-cmake-init.txt" "${HOME}/Libraries/cgal_build" "${HOME}/Libraries/cgal" && \
	make -C "${HOME}/Libraries/cgal_build" install -j ${THREADS_FOR_BUILDS}

###############################################
# Install VCG files - required by openMVS
COPY  	./Libraries/vcg /opt/vcg

###############################################
# Install openMVS
#
RUN	mkdir "${HOME}/Libraries/openmvs_build" && \
	cd "${HOME}/Libraries/openmvs_build" && \
	cmake -C "${HOME}/Libraries/openmvs-cmake-init.txt" "${HOME}/Libraries/openmvs_build" "${HOME}/Libraries/openMVS" && \
	make -C "${HOME}/Libraries/openmvs_build" install -j ${THREADS_FOR_BUILDS}


###############################################
# Install PCL
#
RUN	mkdir "${HOME}/Libraries/pcl_build" && \
	cd "${HOME}/Libraries/pcl_build" && \
	cmake -C "${HOME}/Libraries/pcl-cmake-init.txt" "${HOME}/Libraries/pcl_build" "${HOME}/Libraries/pcl-pcl-1.8.1" && \
	make -C "${HOME}/Libraries/pcl_build" install -j ${THREADS_FOR_BUILDS}

###############################################
# Install rapidJSON
#
RUN	mkdir "${HOME}/Libraries/rapidjson_build" && \
	cd "${HOME}/Libraries/rapidjson_build" && \
	cmake -C "${HOME}/Libraries/rapidjson-cmake-init.txt" "${HOME}/Libraries/rapidjson_build" "${HOME}/Libraries/rapidjson-1.1.0" && \
	make -C "${HOME}/Libraries/rapidjson_build" install -j ${THREADS_FOR_BUILDS}

##########################################################################################################################################
##########################################################################################################################################

FROM base-smt-build

COPY --from=build-workspace /usr /usr
COPY --from=build-workspace /opt /opt
COPY --from=build-workspace ${HOME}/Libraries/opencv_build/bin /usr/local/bin

##############################################
# Install Labjack libraries

COPY ./Libraries/exodriver-master $HOME/Libraries/exodriver-master
RUN  cd $HOME/Libraries/exodriver-master && \
     chmod -R a+rwx * && \
     sudo ./install.sh; exit 0;

COPY ./Libraries/LabJackPython $HOME/Libraries/LabJackPython
RUN cd $HOME/Libraries/LabJackPython && sudo python setup.py install

##############################################
# Build SnakeStrike codebase
RUN cd $HOME && git clone https://github.com/gwjensen/SnakeStrike.git
RUN cd $HOME/SnakeStrike/build && cmake ../ && sudo make install -j ${NUM_THREADS_FOR_BUILDS}

