FROM alpine:3.22.4@sha256:310c62b5e7ca5b08167e4384c68db0fd2905dd9c7493756d356e893909057601

RUN apk add --no-cache gcompat jq bash coreutils rsync sed git

WORKDIR /usr/local
RUN wget -q https://github.com/joshgoebel/wren-console/releases/download/v0.3.1/wren-console-v0.3.1-linux.tar.gz -O - \
  | tar zxf -

WORKDIR /opt/test-runner
COPY package.wren .
RUN wrenc package.wren install
COPY . .
RUN ./bin/post-install.sh
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
