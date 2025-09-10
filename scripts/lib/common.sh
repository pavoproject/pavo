# Copyright (c) 2025 Pokeghost
# SPDX-License-Identifier: BSD-2-Clause

#!/bin/sh

set -euo pipefail


_log() {
    local level="$1"; shift
    printf "[%s] %s\n" "$level" "$*" >&2
}

log_info() { _log INFO "$@"; }
log_warn() { _log WARN "$@"; }
log_err()  { _log ERROR "$@"; }

die() {
    log_err "$*"
    exit 1
}

exists() {
    command -v "$1">/dev/null 2>&1
}

require() {
    local cmd="$1"
    exists "$cmd" || die "Required command not found: $cmd"
}

ensure_dir() {
    local dir="$1"
    [ -d "$dir" ] || mkdir -p "$dir"
}

require_root() {
    [ "$(id -u)" -eq 0 ] || die "This must be run as root"
}

download_file() {
    local url="$1"
    local output="$2"

    log_info "Downloading $(basename "$output")..."
    
    if exists curl; then
        curl -fL --progress-bar "$url" -o "$output"
    elif exists wget; then
        wget -q --show-progress "$url" -O "$output"
    else
        die "No curl or wget available"
    fi
    
    # TODO: Add checksum check
}
