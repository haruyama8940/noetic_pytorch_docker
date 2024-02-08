FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04
WORKDIR /home
#RUN wget -nv https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
#    dpkg -i cuda-keyring_1.0-1_all.deb && \
#    rm cuda-keyring_1.0-1_all.deb

RUN apt-get update && apt-get -y upgrade
SHELL ["/bin/bash", "-c"]
RUN apt install curl gnupg2 lsb-release vim -y
ENV DEBIAN_FRONTEND=noninteractive
RUN apt install -y tzdata
ENV TZ Asia/Tokyo
RUN unset ${DEBIAN_FRONTEND}
#Install ROS
#RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y ros-noetic-desktop-full
RUN apt-get install -y python3-rosinstall python3-catkin-tools python3-rosdep ros-noetic-rqt-*
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; \
                  mkdir -p /home/catkin_ws/src; \
                  cd /home/catkin_ws; \
                  catkin build'
#RUN mkdir -p ~/catkin_ws/src
#RUN cd ~/catkin_ws/ && catkin build
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN echo "source /home/catkin_ws/devel/setup.bash" >> ~/.bashrc

#Install pytorch
RUN apt-get install -y python3-pip
RUN pip3 install networkx
RUN pip install torch==2.0.0 torchvision==0.15.1 torchaudio==2.0.1 --index-url https://download.pytorch.org/whl/cu118

#Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
