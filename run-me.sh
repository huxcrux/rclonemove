#!/bin/bash

local="/data/"

if [ -z "${RCLONE_REMOTE}" ]; then
    echo "No remote Selected exiting"
    exit 1;
fi
if [ -z "${RCLONE_FOLDER}" ]; then
    echo "No folder selected, using /"
fi
remotedrive=$RCLONE_REMOTE
remotefolder=$RCLONE_FOLDER

if [ ! -f /config/rclone.conf ]; then
  echo "cannot find rclone.conf"
  exit 1;
fi

echo "Selected Remote: $remotedrive";
echo "Selected Folder: $remotefolder";

while true
do
  echo "Running rclone move"
  # rclone can take a while. This keeps multiple instances from running.

  echo "-> Starting rclone move -> drive"
  rclone move $local $remotedrive:$remotefolder --config "/config/rclone.conf" --checksum --delete-after  --tpslimit 8 --tpslimit-burst 1  --transfers 10 --min-age 10m -v --bwlimit 9M --delete-empty-src-dirs
  echo "<- Finished rclone move -> drive"

  echo "--------------------------------"

  # Sleep
  sleep 60
done
