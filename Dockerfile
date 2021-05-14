# This is a two stage build
# first we need build-base and friends to build our custom wren_cli
FROM alpine:3.13
RUN apk add --no-cache git build-base

WORKDIR /tmp
RUN git clone https://github.com/joshgoebel/wren-cli && \
    cd wren-cli && \
    git checkout fix_file_ext_removal && \
    make -j4 -C projects/make/

# then we only need jq, bash, and wren_cli for running tests
FROM alpine:3.13
RUN apk add --no-cache jq bash moreutils
COPY --from=0 /tmp/wren-cli/bin/wren_cli /usr/bin
RUN wren_cli --version

WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
