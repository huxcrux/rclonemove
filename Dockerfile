FROM alpine:3.17 AS builder

RUN echo "**** install packages ****" && \
  apk add --no-cache curl==7.88.1-r0 unzip==6.0-r13 bash==5.2.15-r0 && \
  echo "**** install rclone ****" && \
  curl -o rclone-linux-amd64.zip https://downloads.rclone.org/v1.61.1/rclone-v1.61.1-linux-amd64.zip && \
  unzip rclone-linux-amd64.zip && \
  mv rclone-*-linux-amd64/rclone /usr/bin/rclone

FROM alpine:3.17

# Install bash
RUN apk add --no-cache bash==5.2.15-r0

# Copy Rclone binary from builder
COPY --from=builder /usr/bin/rclone /usr/bin/rclone

# Set workdir 
WORKDIR /rclone

# Copy and make .sh file executeble
COPY run-me.sh /rclone/
RUN chmod +x /rclone/run-me.sh

#add volumes
VOLUME /config

#add default environment variables
ENV RCLONE_FOLDER /

ENTRYPOINT ["/rclone/run-me.sh"]
