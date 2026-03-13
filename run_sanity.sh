#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME="bonsai"
IMAGE_NAME="pachkov/bonsai"
INPUT_DIR="$PWD"
SANITY_ARGS=$*


cleanup() {
	echo
	echo "Stopping and removing container '$CONTAINER_NAME'..."
	docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
}

trap cleanup INT TERM

if docker ps --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
	echo "Container '$CONTAINER_NAME' is already running. Restarting it..."
	docker rm -f "$CONTAINER_NAME" >/dev/null
elif docker ps -a --format '{{.Names}}' | grep -Fxq "$CONTAINER_NAME"; then
	echo "Container '$CONTAINER_NAME' exists but is not running. Removing it..."
	docker rm "$CONTAINER_NAME" >/dev/null
fi

echo "Starting container '$CONTAINER_NAME' from image '$IMAGE_NAME'..."
docker run -d \
	--name "$CONTAINER_NAME" \
	-v "$INPUT_DIR":/mnt \
	"$IMAGE_NAME" >/dev/null

echo "Container is running."
echo "Mounted: $INPUT_DIR -> /mnt"
# start sanity in the container
echo "Starting bonsai_scout in the container..."
docker exec \
    -w /mnt \
    -t bonsai \
    bash -c "mkdir -p sanity_results && /sanity/bin/Sanity $SANITY_ARGS -e 1 -max_v 1 -d sanity_results"

echo "Sanity run finished."

echo
echo "Stopping and removing container '$CONTAINER_NAME'..."
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
