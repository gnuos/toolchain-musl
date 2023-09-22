# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM scratch AS minimal
ADD alpine.tar.gz /

FROM scratch AS tz
COPY --from=minimal / /
ENV PATH=/usr/sbin:/usr/bin:/sbin:/bin
RUN apk add tzdata --no-cache && rm -rf /var/cache/apk/*

FROM scratch AS build-base
COPY --from=minimal / /
ARG ALPINE_VERSION
ARG BUILD_DATE
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="MIT" \
    org.label-schema.name="alpine" \
    org.label-schema.description="Alpine Linux image" \
    org.label-schema.url="https://alpinelinux.troyfontaine.com" \
    org.label-schema.vcs-url="https://github.com/troyfontaine/alpinelinux" \
    org.label-schema.docker.cmd="docker run --rm troyfontaine/alpinelinux:$ALPINE_VERSION [args]" \
    org.label-schema.schema-version="1.0" \
    com.troyfontaine.architecture=$BUILDPLATFORM \
    com.troyfontaine.alpine-version=$ALPINE_VERSION \
    maintainer="gnuos"

COPY --from=tz /usr/share/zoneinfo/PRC /etc/localtime

# Fix certificate issues when setting to use the https repositories
RUN apk add ca-certificates --no-cache && rm -rf /var/cache/apk/*

# Upgrade the repository URLs to HTTPS
RUN printf \
    "https://dl-cdn.alpinelinux.org/alpine/v%s/main\nhttps://dl-cdn.alpinelinux.org/alpine/v%s/community" \
    $VERSION $VERSION > /etc/apk/repositories && \
    apk upgrade --available --no-cache && rm -rf /var/cache/apk/*


FROM scratch AS alpine-img
COPY --from=build-base / /

CMD ["/bin/sh"]

