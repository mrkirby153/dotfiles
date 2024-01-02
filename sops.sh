#!/usr/bin/env bash

exec nix run nixpkgs#sops -- "$@"