FROM alpine:3.15 AS builder

RUN echo "**** install packages ****" && \
  apk add --no-cache curl==7.80.0-r0 unzip==6.0-r9 bash==5.1.16-r0 && \
  echo "**** install rclone ****" && \
  curl -o rclone-linux-amd64.zip https://downloads.rclone.org/v1.58.0/rclone-v1.58.0-linux-amd64.zip && \
  unzip rclone-linux-amd64.zip && \
  mv rclone-*-linux-amd64/rclone /usr/bin/rclone

FROM alpine:3.15

# Install bash
RUN apk add --no-cache bash==5.1.16-r0

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
