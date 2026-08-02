*** Settings ***
Documentation    Two-device parallel flow variables — pass UDIDs via ``-v`` at runtime.
Resource    android_caps.robot


*** Variables ***
# UDIDs = first column of ``adb devices`` for each phone (no angle brackets).
# Example:
# robot -d Results -v PARALLEL_UDID_DRIVER:emulator-5554 -v PARALLEL_UDID_OWNER:emulator-5556 Tests/Parallel/example.robot
${PARALLEL_ALIAS_DRIVER}          driver
${PARALLEL_ALIAS_OWNER}           owner
${PARALLEL_UDID_DRIVER}           ${EMPTY}
${PARALLEL_UDID_OWNER}            ${EMPTY}
${PARALLEL_DRIVER_SYSTEM_PORT}    8200
${PARALLEL_OWNER_SYSTEM_PORT}     8201
