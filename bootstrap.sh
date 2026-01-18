#!/bin/bash

# Simple prerequisite checker (no installs yet).
# Future versions will auto-install missing deps.

missing=()

function require_cmd() {
    local name="$1"
    if ! command -v "$name" >/dev/null 2>&1; then
        missing+=("$name")
    fi
}

require_cmd zsh
require_cmd nvm
require_cmd pnpm

if (( ${#missing[@]} > 0 )); then
    echo "Missing prerequisites: ${missing[*]}" >&2
    echo "Install them manually for now. Future versions will install them automatically." >&2
    exit 1
fi

echo "All prerequisites present: zsh, nvm, pnpm."

