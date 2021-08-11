# Use same alphine as the base for the runtime image
FROM python:3.9.6-alpine3.14

MAINTAINER calvin <c6supper@hotmail.com>

ENV SARTUN_DIR /sartun
ENV SARTUN_INITIALIZED_MARK $SARTUN_DIR/patched
RUN mkdir -p $SARTUN_DIR
COPY ./version $SARTUN_DIR/version
COPY ./docker-entrypoint.sh /sartun/docker-entrypoint.sh

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --update bc grep bash gettext git gcc musl-dev postgresql-dev postgresql-libs libffi-dev && \
    apk add --virtual temppkg g++ busybox-extras &&  \
    apk del temppkg && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

# Add configuration scripts

# default configuration for istio
ENV RUN_AFTER_SIDECAR no

ENV SARTUN_PORT 8008

# initilization for the first time
ENTRYPOINT ["/sartun/docker-entrypoint.sh"]

EXPOSE 8008/tcp

# CMD ["openvpn --cd $OPENVPN_DIR --config $OVPN_CONFIG 2>&1"]
CMD ["daphne -p $SARTUN_PORT greaterwms.asgi:application"]