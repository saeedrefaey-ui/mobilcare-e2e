#!/usr/bin/env bash
# Start Appium with Android SDK env loaded.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

# shellcheck disable=SC1091
source scripts/env.sh

PORT="${APPIUM_PORT:-4723}"
HOST="${APPIUM_HOST:-127.0.0.1}"

if [[ -z "${ANDROID_HOME:-}" ]]; then
  echo "WARNING: ANDROID_HOME not set. Install Android Studio SDK or set ANDROID_HOME in your shell."
fi

echo "Starting Appium at http://${HOST}:${PORT}"
exec npx appium --address "$HOST" --port "$PORT"
