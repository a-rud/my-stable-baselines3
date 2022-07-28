#!/bin/bash

#GPU_PARENT=nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
#CPU_PARENT=ubuntu:18.04

CPU_PARENT=ubuntu:20.04
GPU_PARENT=nvidia/cuda:11.3.1-base-ubuntu20.04

TAG=arudl/my-stable-baselines3
LATEST=latest
VERSION=$(cat ./stable_baselines3/version.txt) # version of SB3

if [[ ${USE_GPU} == "True" ]]; then
  PARENT=${GPU_PARENT}
  PYTORCH_DEPS="cudatoolkit=11.3"
else
  PARENT=${CPU_PARENT}
  PYTORCH_DEPS="cpuonly"
  #TAG="${TAG}-cpu" # tag must always be the same since using only one repo
  # Mark the images as CPU via versions
  VERSION="${VERSION}-cpu"
  LATEST="${LATEST}-cpu"
fi

echo "docker build --build-arg PARENT_IMAGE=${PARENT} --build-arg PYTORCH_DEPS=${PYTORCH_DEPS} --tag ${TAG}:${VERSION} ."
docker build --build-arg PARENT_IMAGE=${PARENT} --build-arg PYTORCH_DEPS=${PYTORCH_DEPS} --tag ${TAG}:${VERSION} .
echo "docker tag ${TAG}:${VERSION} ${TAG}:${LATEST}"
docker tag ${TAG}:${VERSION} ${TAG}:${LATEST}

