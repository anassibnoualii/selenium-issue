#!/bin/bash
#This is the official selenium images
SELENIUM_TAG=4.15.0-20231110

images=("standalone-chrome" "standalone-edge" "standalone-firefox" "node-docker" "hub")
for image in "${images[@]}"; do
  echo "Building image for:" "$image"
  #This is the tag that we will use in dev testing
  TAG="selenium/$image:nightly-20231121"
  docker build --no-cache -f ./"$image"/Dockerfile --build-arg SELENIUM_TAG=$SELENIUM_TAG -t "$TAG" .
  echo "Built image tag:" "$TAG"
done
