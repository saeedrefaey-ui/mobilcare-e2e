#!/usr/bin/env bash
# Run MobilCare Robot suites. Requires Appium on ${APPIUM_SERVER_URL:-http://127.0.0.1:4723}.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# shellcheck disable=SC1091
source .venv/bin/activate
# shellcheck disable=SC1091
source scripts/env.sh

SUITE="${1:-Tests/}"
EXTRA_ARGS=("${@:2}")

mkdir -p Results

echo "==> Running: robot -d Results ${EXTRA_ARGS[*]:-} ${SUITE}"
robot -d Results "${EXTRA_ARGS[@]}" "$SUITE"
