FROM alpine:3.7
MAINTAINER Shion <shion.chow@gmail.com>

ENV RELAY_THREADS 10
ENV MIN_PORT 49152
ENV MAX_PORT 65535
ENV REALM localhost
ENV MAX_BPS 1000000
ENV AUTH_SECRET 123456
ENV SUBJ /C=CN/ST=BeiJing/L=BeiJing/O=Shion/OU=Shion/CN=localhost

RUN apk add --no-cache openssl coturn \
    && openssl req -x509 -newkey rsa:2048 -keyout /etc/turn_server_pkey.pem -out /etc/turn_server_cert.pem -days 99999 -nodes -subj "$SUBJ"

EXPOSE 3478/tcp
EXPOSE 3478/udp
EXPOSE 49152-65535/tcp
EXPOSE 49152-65535/udp

CMD turnserver -f -a -m $RELAY_THREADS --use-auth-secret --stale-nonce --no-loopback-peers --no-multicast-peers --mobility --no-cli --min-port=$MIN_PORT --max-port=$MAX_PORT --realm=$REALM --max-bps=$MAX_BPS --static-auth-secret=$AUTH_SECRET --cert=/etc/turn_server_cert.pem --pkey=/etc/turn_server_pkey.pem --rest-api-separator=: