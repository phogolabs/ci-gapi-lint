FROM alpine:3.14

ARG APP_VERSION="1.28.0"
ARG APP_NAME="Google API Linter"
ARG APP_DESCRIPTION=""
ARG APP_SOURCE="https://github.com/phogolabs/google-api-linter-action"

LABEL com.github.actions.name=$APP_NAME
LABEL com.github.actions.icon="check"
LABEL com.github.actions.color="green"
LABEL com.github.actions.description=$APP_DESCRIPTION

LABEL org.opencontainers.image.title=$APP_NAME
LABEL org.opencontainers.image.version=$APP_VERSION
LABEL org.opencontainers.image.description=$APP_DESCRIPTION
LABEL org.opencontainers.image.source=$APP_SOURCE

# add the required packages
RUN apk add --no-cache bash=5.1.16-r0
# https://stackoverflow.com/questions/34729748/installed-go-binary-not-found-in-path-on-alpine-linux-docker
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# download gokart
ADD https://github.com/googleapis/api-linter/releases/download/v${APP_VERSION}/api-linter-${APP_VERSION}-linux-amd64.tar.gz /tmp/google-api-linter.tar.gz
# unpack the package
RUN tar -xzf /tmp/google-api-linter.tar.gz -C /usr/bin && rm /tmp/google-api-linter.tar.gz && chmod +x /usr/bin/api-linter
# enable the entry point
COPY main.sh /usr/bin/main
# make sure that the entry point has the correct attributes
RUN chmod +x /usr/bin/main

ENTRYPOINT ["/usr/bin/main"]
