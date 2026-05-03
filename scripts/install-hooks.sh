#!/bin/sh
# Activate the in-repo privacy-guard hooks.
# Run once after cloning the repo.
set -eu
git config core.hooksPath hooks
chmod +x hooks/* 2>/dev/null || true
echo "OK: core.hooksPath = $(git config core.hooksPath)"
echo "Pre-commit and pre-push privacy guards are active."
