#!/usr/bin/env bash

# Transparent wrapper — routes all `ros2` calls into a persistent Docker
# container. The container is started on first use and kept running.

source "$HOME/pers/scripts/utils.sh"

set -euo pipefail

CONTAINER="${ROS2_CONTAINER:-ros2_containerized}"
DISTRO="${ROS_DISTRO:-lyrical}"
IMAGE="${ROS_IMAGE:-osrf/ros:${DISTRO}-desktop}"

_start_container() {
  log "[ros2-docker] Starting container '${CONTAINER}' (${IMAGE})…"

  docker rm -f "${CONTAINER}" 2>/dev/null || true
  docker run -d \
    --name "${CONTAINER}" \
    --network host \
    --user "$(id -u):$(id -g)" \
    -v "${HOME}:${HOME}:z" \
    -e "HOME=${HOME}" \
    -w "${HOME}" \
    "${IMAGE}" \
    sleep infinity >/dev/null
  sleep 0.3
}

if ! docker ps --format '{{.Names}}' | grep -qx "${CONTAINER}"; then
  _start_container
fi

exec docker exec \
  --interactive \
  --user "$(id -u):$(id -g)" \
  --workdir "$(pwd)" \
  "${CONTAINER}" \
  bash -c 'source /opt/ros/$ROS_DISTRO/setup.sh 2>/dev/null; exec ros2 "$@"' \
  -- "$@"
