#!/bin/bash

source ./bootstrap.sh

# authenticate using docker
echo -e "${orange}Authenticating...${reset}";
login="sudo $(aws ecr get-login --region eu-central-1 --profile sbc --no-include-email)"
eval $login

echo -e "${orange}Building the image ...${reset}";
docker build -t docker-microservice-template ../../. --no-cache

echo -e "${orange}Tagging the image ...${reset}";
docker tag sbc-typo3:latest 367608115228.dkr.ecr.eu-central-1.amazonaws.com/docker-microservice-template:latest


echo -e "${orange}Pushing the image ...${reset}";
docker push 367608115228.dkr.ecr.eu-central-1.amazonaws.com/docker-microservice-template:latest

echo -e "${green}Done!${reset}";
