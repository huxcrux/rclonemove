#!/bin/bash

lock="rclone.pid"
local="/data/"
lastrunf="lastrun.txt"

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
  if [ ! -f $lastrunf ]; then
    echo 0 > $lastrunf;
  fi

  now=$(date +%s);
  lastrun=`cat $lastrunf`;
  diff=$(( $now - $lastrun ));

  if [ $diff -gt 3599 ];
  then
      echo "Running rclone move"
      echo $now > $lastrunf;
      if [ ! -f ${lock} ]; then
              # create a lockfile containing PID...
              # rclone can take a while. This keeps multiple instances from running.
              echo "$$" > ${lock}

              echo "-> Starting rclone move -> drive"
              rclone move $local $remotedrive:$remotefolder --config "/config/rclone.conf" --checksum --delete-after  --tpslimit 8 --tpslimit-burst 1  --transfers 10 --min-age 60m -v --bwlimit 9M
              echo "<- Finished rclone move -> drive"

              echo "--------------------------------"

              # remove lock.
              rm ${lock}

              # success!
      else
              # error!
              echo "Update already running on PID $(cat ${lock})."
      fi
  else
      echo "less then one hour, trying again soon";
      sleep 60;
  fi;
done
