#!/usr/bin/env bash
if [ ! -f wren_modules/wren-testie-wrapper ]; then
    cp -R wrappers/wren-testie wren_modules/wren-testie-wrapper
fi