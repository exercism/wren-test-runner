FROM alpine:3.23.5@sha256:fd791d74b68913cbb027c6546007b3f0d3bc45125f797758156952bc2d6daf40
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
