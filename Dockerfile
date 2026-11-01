FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a
ARG VERSION=v0.3.1

RUN apk add --no-cache gcompat jq bash coreutils rsync sed git

WORKDIR /usr/local
RUN wget -q https://github.com/joshgoebel/wren-console/releases/download/${VERSION}/wren-console-${VERSION}-linux.tar.gz -O - \
  | tar zxf -

WORKDIR /opt/test-runner
COPY package.wren .
RUN wrenc package.wren install
COPY . .
RUN ./bin/post-install.sh
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
