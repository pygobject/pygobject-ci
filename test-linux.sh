#!/bin/bash

set -e

DOCKERFILE="Dockerfile.$DOCKERIMAGE"
if [ ! -f "_ci_cache/$DOCKERIMAGE" ]; then
    docker build -t "$DOCKERIMAGE" -f "$DOCKERFILE" .
    mkdir -p _ci_cache;
    docker image save "$DOCKERIMAGE" -o "_ci_cache/$DOCKERIMAGE";
fi;
docker image load -i "_ci_cache/$DOCKERIMAGE"
docker run --volume "$(pwd):/app" --workdir "/app" --tty --detach "$DOCKERIMAGE" bash > container_id
docker exec "$(cat container_id)" bash -x test-docker.sh $PYTHON
docker stop "$(cat container_id)"
