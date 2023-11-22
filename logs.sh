#!/bin/bash

log_dir="container_logs"
mkdir -p "$log_dir"

while true; do
  new_containers=$(docker ps --filter "expose=5900/tcp" --format "{{.ID}}")

  for container_id in $new_containers; do
    log_file="$log_dir/$container_id.log"
    log_file_error="$log_dir/$container_id-error.log"
    echo "Inspecting and copying log file for container: $container_id"

    # Copy the log file from the container's LogPath to a temporary location
    temp_log=$(docker logs "$container_id")
    # Check if the log file contains "Failed to run"
    if grep -q "Failed to run" "$temp_log"; then
      echo "Appending -error to the log file: $container_id"
      echo "$temp_log" > "$log_file_error"
    else
      echo "Renaming the log file: $container_id"
      echo "$temp_log" > "$log_file"
    fi
  done
done