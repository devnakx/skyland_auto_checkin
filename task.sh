#!/bin/bash
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOTDIR"

export SKYLAND_TOKEN="token1;token2;token3;"

./venv/bin/python3 ./main.py
