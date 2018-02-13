#!/bin/bash

set -e

DOCKERFILE="Dockerfile.$DOCKERIMAGE"
if [ ! -f "_ci_cache/$DOCKERIMAGE" ]; then
    docker build --build-arg HOST_USER_ID="$UID" -t "$DOCKERIMAGE" -f "$DOCKERFILE" .
    mkdir -p _ci_cache;
    docker image save "$DOCKERIMAGE" -o "_ci_cache/$DOCKERIMAGE";
fi;
docker image load -i "_ci_cache/$DOCKERIMAGE"
docker run -e PYENV_VERSION="${PYENV_VERSION}" --volume "$(pwd):/home/user/app" --workdir "/home/user/app" --tty --detach "$DOCKERIMAGE" bash > container_id
docker exec "$(cat container_id)" bash -x test-docker.sh
docker stop "$(cat container_id)"
