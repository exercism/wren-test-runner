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
RUN apk add --no-cache jq bash coreutils moreutils rsync sed
COPY --from=0 /tmp/wren-console/bin/wrenc /usr/bin
RUN wrenc -v

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
