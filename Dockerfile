FROM alpine:3.12
LABEL maintainer="Arnaud Duforat https://github.com/neokeld"

RUN apk --update add curl bash && \
    rm -rf /var/cache/apk/*

ADD /load-config.sh /
ADD /upload-consul-file.sh /
VOLUME /config

ENV INIT_SLEEP_SECONDS=5
ENV CONSUL_URL=localhost
ENV CONSUL_PORT=8500
ENV CONFIG_DIR=/config
ENV ENABLE_SPRING=true
ENV ENABLE_MICRONAUT=false

CMD /load-config.sh
