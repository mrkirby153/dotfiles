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
    NIX_CMD="switch"
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
user="${USER:-$(whoami)}"
flake_ref="$user@$actual_hostname"
configuration_name="${CONFIGURATION:-$flake_ref}"

echo "Using configuration: $configuration_name"

nix run --extra-experimental-features "nix-command flakes" . "$NIX_CMD" -- \
    --flake ".#$configuration_name" \
    -b backup \
    --extra-experimental-features "nix-command flakes"