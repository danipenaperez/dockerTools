#!/bin/bash

cat  << "EOF"
 ____   ___   ____ _  _______ ____    _____ ___   ___  _     
|  _ \ / _ \ / ___| |/ / ____|  _ \  |_   _/ _ \ / _ \| |    
| | | | | | | |   | ' /|  _| | |_) |   | || | | | | | | |    
| |_| | |_| | |___| . \| |___|  _ <    | || |_| | |_| | |___ 
|____/ \___/ \____|_|\_\_____|_| \_\   |_| \___/ \___/|_____|
                                                             
@ The freak: danipenaperez 
@ Perpetrated on : Feb 2019

This tool look for containers (running or not) related with the image:version that you want to purge 
from you local docker repository.
Usage: ./dockerRemoveImageAndContainers.sh repository version
repository: The image name (i.e mycompany/service1)
version: 0.0.1 , 5.0.1 , if null will get default value "lastest" 

EOF

#Set vars
IMAGE_NAME=$1
IMAGE_VERSION='lastest'
if [ "$2" ]
then
IMAGE_VERSION=$2
fi

TARGET="$IMAGE_NAME:$IMAGE_VERSION"

DOCKER_IMAGES_LIST_ID=$(docker images |grep $IMAGE_NAME| grep $IMAGE_VERSION | awk '{print $3}')
echo "las imagenes son "$DOCKER_IMAGES_LIST_ID

#############
# CONTAINERS 
#############
#Looking for Containers related with the passed IMAGE info
echo "Looking for Containers related with the passed IMAGE info: " $TARGET " (imageID:" $DOCKER_IMAGES_LIST_ID ")"
DOCKER_LIST=$(docker container ls --all|grep $DOCKER_IMAGES_LIST_ID | awk '{print $1}')


if [ "$DOCKER_LIST" = "" ]
then
	echo "Not found Containers related to Delete with " $TARGET
else
	echo 'The following containers was found :'
	echo $DOCKER_LIST
	echo "Are you sure to delete them? (Y/n)"
	read CONFIRM_DELETE_CONTAINERS

	if [ "$CONFIRM_DELETE_CONTAINERS" = "n" ]
	then
		echo "Aborted Execution"
		exit -1
	fi
	#GET Container ID List
	docker rm --force -v $DOCKER_LIST
	echo 'Succesfully deleted Docker Containers -> '$DOCKER_LIST
fi



#############
# IMAGES 
#############
#Looking for Containers related with the passed IMAGE info
echo ""
echo "Looking for Images related with the passed IMAGE info " $TARGET
#docker rmi $(docker images |grep "$1"| awk '{print $3 }'
DOCKER_IMAGES_LIST=$(docker images |grep "$IMAGE_NAME"| grep "$IMAGE_VERSION")

if [ "$DOCKER_IMAGES_LIST" = "" ]
then
	echo "Not found Images that match " $TARGET
else
	echo 'The following images was found'
	echo $DOCKER_IMAGES_LIST
	echo "Are you sure to delete them? (Y/n)"
	read CONFIRM_DELETE_IMAGES

	if [ "$CONFIRM_DELETE_IMAGES" = "n" ]
	then
		echo "Aborted Execution"
		exit -1
	fi
	#GET Container ID List
	DOCKER_IMAGES_LIST_ID=$(docker images |grep $IMAGE_NAME| grep $IMAGE_VERSION | awk '{print $3}')
	docker rmi -f $DOCKER_IMAGES_LIST_ID
	echo 'Succesfully deleted Docker Images -> ' $DOCKER_IMAGES_LIST_ID
fi	

exit 0
