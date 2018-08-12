# Rclone move docker container

## Usage
docker create \
 --name=rclonemove \
 -v <config dir>:/config \
 -v <local data dir>:/data \
 -e RCLONE_REMOTE=<remote> \
 <image>

You can also specify a folder inside your remote by adding:
-e RCLONE_FOLDER=<remote> \
