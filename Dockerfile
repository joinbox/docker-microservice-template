FROM ubuntu:16.04

LABEL maintainer="Joinbox <hosting@joinbox.com>"

# update && install required software
RUN apt -y update && apt install -y
RUN apt -y install nano make gcc g++ git-core sudo htop curl vim apt-utils unattended-upgrades

# add ubuntu user
RUN adduser --group --system --disabled-password --gecos "" ubuntu
RUN echo "ubuntu:G5fFXXCYyd6rIWnc5w34VD8s" | chpasswd

# add to sudoers
RUN usermod -aG sudo ubuntu
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# disable the root user
RUN sudo passwd -l root

# switch user
USER ubuntu

# Install node js
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Configure npm
RUN mkdir -p /home/ubuntu/npm && npm config set prefix /home/ubuntu/npm
ENV PATH $PATH:/home/ubuntu/npm/bin
