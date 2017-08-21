#!/bin/bash

set -e

docker build -t myimage -f "$DOCKERFILE" .
docker run --volume "$(pwd):/app" --workdir "/app" --tty --detach myimage bash > container_id
docker exec "$(cat container_id)" bash -x test-docker.sh $PYTHON
docker stop "$(cat container_id)"
