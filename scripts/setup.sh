#!/usr/bin/env bash
# Install Python (Robot) + Node (Appium) dependencies for MobilCare E2E.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> Python venv + Robot Framework"
python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
robot --version

echo "==> Appium (local via npm)"
npm install
npx appium driver install uiautomator2@3.8.2

echo ""
echo "==> Android SDK"
# shellcheck disable=SC1091
source scripts/env.sh
if [[ -n "${ANDROID_HOME:-}" ]]; then
  echo "ANDROID_HOME=${ANDROID_HOME}"
  adb version | head -1
else
  echo "WARNING: Android SDK not found. Install Android Studio:"
  echo "  https://developer.android.com/studio"
fi
