FROM ubuntu:18.04
MAINTAINER Hugo Blom hugo.blom1@gmail.com

#update and install packages
RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
  sudo \
  unzip \
  man-db \
	curl && \
 echo "**** install rclone ****" && \
 curl -o rclone-linux-amd64.deb https://downloads.rclone.org/v1.49.5/rclone-v1.49.5-linux-amd64.deb && \
 sudo dpkg -i rclone-linux-amd64.deb && \
 rm rclone-linux-amd64.deb


#set workdir and copy .sh
WORKDIR /rclone
COPY run-me.sh /rclone/

#make .sh executeble
RUN chmod +x /rclone/run-me.sh

#add volumes
VOLUME /config

#add default environment variables
ENV RCLONE_FOLDER /

ENTRYPOINT ["/rclone/run-me.sh"]
