# This is a two stage build
# first we need build-base and friends to build our custom wren_cli
FROM alpine:3.13
RUN apk add --no-cache git build-base

WORKDIR /tmp
RUN git clone https://github.com/joshgoebel/wren-console && \
    cd wren-console/deps && \
    git clone https://github.com/joshgoebel/wren-essentials && \
    cd .. && \
    make -j4 -C projects/make/

# then we only need jq, bash, and wren_cli for running tests
FROM alpine:3.13
RUN apk add --no-cache jq bash coreutils moreutils rsync sed git
COPY --from=0 /tmp/wren-console/bin/wrenc /usr/bin

WORKDIR /opt/wren_modules
RUN git clone https://github.com/joshgoebel/wren-package

WORKDIR /opt/test-runner
COPY package.wren .
RUN wrenc package.wren install
COPY . .
RUN ./bin/post-install.sh
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
