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


# Detect nom

if ! type nom > /dev/null || [ ! -t 1 ]; then
    nix="nix"
else
    nix="nom"
fi

echo "Using $nix"

nix_linux() {
    actual_hostname="${HOSTNAME:-$(hostname)}"
    user="${USER:-$(whoami)}"
    flake_ref="$user@$actual_hostname"
    configuration_name="${CONFIGURATION:-$flake_ref}"

    echo "Using Linux configuration: $configuration_name"

    # Build the current configuration
    if [ "$NIX_CMD" = "build" ]; then
        out_link="./result"
    else
        temp_dir="$(mktemp -d)"
        trap 'rm -rf "$temp_dir"' EXIT
        out_link="$temp_dir/result"
    fi
    ref=".#homeConfigurations.\"$configuration_name\".config.home.activationPackage"
    $nix build --extra-experimental-features "nix-command flakes" "$ref" --out-link "$out_link"
    if [ $? -ne 0 ]; then
        echo "Failed to build configuration"
        exit 1
    fi

    if [ "$NIX_CMD" = "switch" ]; then
        echo "Activating configuration..."
        "$out_link/activate"
    fi
}

nix_darwin() {
    actual_hostname="${HOSTNAME:-$(hostname)}"
    actual_hostname=${actual_hostname%%.*}
    user="${USER:-$(whoami)}"
    flake_ref="$user@$actual_hostname"
    configuration_name="${CONFIGURATION:-$flake_ref}"

    echo "Using Darwin configuration: $configuration_name"
    ref=".#darwinConfigurations.\"$configuration_name\".system"

    if [ "$NIX_CMD" = "build" ]; then
        out_link="./result"
    else
        temp_dir="$(mktemp -d)"
        trap 'rm -rf "$temp_dir"' EXIT
        out_link="$temp_dir/result"
    fi

    $nix build --extra-experimental-features "nix-command flakes" "$ref" --out-link "$out_link"
    if [ $? -ne 0 ]; then
        echo "Failed to build configuration"
        exit 1
    fi
    
    if [ "$NIX_CMD" = "switch" ]; then
        echo "Activating user configuration..."
        "$out_link/activate-user"

        echo "Activating system configuration..."
        if [ "$USER" != "root" ]; then
            sudo "$out_link/activate"
        else
            "$out_link/activate"
        fi
    fi
}

case "$(uname)" in
    "Linux")
    nix_linux
    ;;
    "Darwin")
    nix_darwin
    ;;
    *)
    echo "Unsupported OS: $(uname)"
    exit 1
    ;;
esac