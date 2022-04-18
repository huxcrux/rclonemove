FROM alpine:3.15

#update and install packages
RUN apk add --no-cache curl==7.80.0-r0 unzip==6.0-r9 bash==5.1.16-r0
RUN echo "**** install rclone ****" && \
  curl -o rclone-linux-amd64.zip https://downloads.rclone.org/v1.58.0/rclone-v1.58.0-linux-amd64.zip && \
  unzip rclone-linux-amd64.zip && \
  rm rclone-linux-amd64.zip && \
  mv rclone-*-linux-amd64/rclone /usr/bin/rclone && \
  rm -rf rclone-*-linux-amd64

RUN apk del curl unzip

#set workdir and copy .sh
WORKDIR /rclone
COPY run-me.sh /rclone/

#make .sh executeble
RUN chmod +x /rclone/run-me.sh

#make .sh executeble
RUN chmod +x /rclone/run-me.sh

#add volumes
VOLUME /config

#add default environment variables
ENV RCLONE_FOLDER /

ENTRYPOINT ["/rclone/run-me.sh"]
