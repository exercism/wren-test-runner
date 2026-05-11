FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11
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
