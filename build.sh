#!/bin/sh

set -eu

CWD=$(basename "$PWD")

build() {
    docker build . --tag "$CWD"
}

clean() {
    docker system prune -f
}

dev() {
    mkdir -p output
    docker run --rm --gpus=all --entrypoint=sh \
        -v huggingface:/home/huggingface/.cache/huggingface \
        -v "$PWD"/output:/home/huggingface/output \
        -it "$CWD"
}

run() {
    shift
    echo "$CWD"
    echo "$@"
    mkdir -p output
    docker run --rm \
        -v huggingface:/home/huggingface/.cache/huggingface \
        -v "$PWD"/output:/home/huggingface/output \
        "$CWD" "$@"
}

case ${1:-build} in
    build) build ;;
    clean) clean ;;
    dev) dev "$@" ;;
    run) run "$@" ;;
    *) echo "$0: No command named '$1'" ;;
esac
