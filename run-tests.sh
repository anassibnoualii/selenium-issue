#!/bin/bash

# Create 10 folders and run the Python script in each folder
for i in {1..10}; do
  folder_name="folder_$i"
  mkdir -p "$folder_name"

  # Run the Python script in the background for each folder
  (cd "$folder_name" && python3 -m robot ../tests/test.robot) &
done

# Wait for all background jobs to finish
wait
