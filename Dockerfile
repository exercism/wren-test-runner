FROM alpine:latest

RUN apk add --no-cache gcompat jq bash coreutils moreutils rsync sed git

WORKDIR /usr/local
RUN wget -q https://github.com/joshgoebel/wren-console/releases/download/v0.3.1/wren-console-v0.3.1-linux.tar.gz -O - \
  | tar zxf - 

WORKDIR /opt/test-runner
COPY package.wren .
RUN wrenc package.wren install
COPY . .
RUN ./bin/post-install.sh
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
