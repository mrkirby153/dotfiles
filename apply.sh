#!/usr/bin/env sh

usage() {
    echo "Usage: $0 [build|apply]" >&2
}

if [ $# -eq 0 ]; then
    COMMAND=apply
elif [ $# -eq 1 ]; then
    COMMAND=$1
else
    usage
    exit 1
fi

case "$COMMAND" in
    "apply")
    NIX_CMD="apply"
    ;;
    "build")
    NIX_CMD="build"
    ;;
    *)
    usage
    exit 1
    ;;
esac

actual_hostname="${HOSTNAME:-$(hostname)}"

nix run --extra-experimental-features "nix-command flakes" . "$NIX_CMD" -- \
    --flake ".#$actual_hostname" \
    -b backup \
    --extra-experimental-features "nix-command flakes"