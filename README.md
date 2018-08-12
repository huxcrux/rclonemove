# Rclone move docker container

## Usage
docker create \
 --name=rclonemove \
 -v <config dir>:/config \
 -v <local data dir>:/data \
 -e RCLONE_REMOTE=<remote> \
 bl0m1/rclonemove

####optinal
You can also specify a folder inside your remote (if you want to use something other then the root folder, this can also be specified in your rclone.conf) by adding:
-e RCLONE_FOLDER=<remote> \

###Rclone.conf
Place your rclone.conf in your /config volume.
