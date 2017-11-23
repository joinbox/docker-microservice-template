FROM ubuntu:16.04

LABEL maintainer="Joinbox <hosting@joinbox.com>"

# update && install required software
RUN apt -y update && apt install -y
RUN apt -y install nano make gcc g++ git-core sudo htop curl vim apt-utils

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

# Copy deployment key for github
RUN mkdir -p /home/ubuntu/.ssh
RUN chmod -R 777 /home/ubuntu/.ssh
ADD docker/secure/REPLACE_DEPLOYMENT_KEY /home/ubuntu/.ssh/REPLACE_DEPLOYMENT_KEY
RUN echo "IdentityFile /home/ubuntu/.ssh/REPLACE_DEPLOYMENT_KEY" >> ~/.ssh/config
RUN sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/REPLACE_DEPLOYMENT_KEY
RUN sudo chmod 600 /home/ubuntu/.ssh/REPLACE_DEPLOYMENT_KEY

# make sure ssh knows github.com
RUN touch ~/.ssh/known_hosts
RUN sudo chmod 777 ~/.ssh/known_hosts
RUN ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN sudo chown -R ubuntu:ubuntu /home/ubuntu/.ssh
RUN sudo chmod 600 ~/.ssh/known_hosts
RUN sudo chmod -R 700 /home/ubuntu/.ssh

# Install node js
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Configure npm
RUN mkdir -p /home/ubuntu/npm && npm config set prefix /home/ubuntu/npm
ENV PATH $PATH:/home/ubuntu/npm/bin

# Remove deployment key for github
RUN rm -f ~/.ssh/REPLACE_DEPLOYMENT_KEY
