#!/bin/bash

# Check if podman is installed
if [ -z $(command -v podman) ]; then
    echo "Podman is required"
    exit 1
fi

# Check if output directory exists else create it
if [ ! -d "./iso-output" ]; then
    mkdir ./iso-output
fi

# Build ISO image
printf "\n\033[1;33mCreating an ISO image...\n\n\033[0m"
if ! sudo podman run --rm --privileged --volume ./iso-output:/build-container-installer/build --security-opt label=disable --pull=newer \
ghcr.io/jasonn3/build-container-installer:latest \
VERSION=40 \
IMAGE_REPO=ghcr.io/shans10 \
IMAGE_NAME=sb-dx \
IMAGE_TAG=latest \
VARIANT=Silverblue; then
    printf "\n\033[0;31mFAILURE!"
    exit 1
fi

# Rename ISO
sudo chown $USER:$USER iso-output/*
ISONAME="sb-dx-40-$(date +"%Y%m%d")"
mv iso-output/deploy.iso iso-output/$ISONAME.iso
mv iso-output/deploy.iso-CHECKSUM iso-output/$ISONAME.iso-CHECKSUM
printf "\n\033[0;32mSUCCESS!"
