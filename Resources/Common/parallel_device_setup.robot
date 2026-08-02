*** Settings ***
Documentation    Two-device Appium sessions — open, switch, and close parallel MobilCare apps on Android.
Library    AppiumLibrary
Library    String
Resource    ../Variables/global_variables.robot
Resource    ../Variables/android_caps.robot
Resource    ../Variables/parallel_devices_variables.robot
Resource    setup_teardown.robot


*** Keywords ***
Normalize Parallel Adb Udid
    [Documentation]    Strips spaces; unwraps values like ``<emulator-5554>`` to ``emulator-5554``.
    [Arguments]    ${udid}
    ${normalized}=    Strip String    ${udid}
    ${normalized}=    Replace String Using Regexp    ${normalized}    ^\\s*<(.+)>\\s*$    \\1
    RETURN    ${normalized}

Reject Documentation Style Parallel Udid
    [Documentation]    Fails early when a placeholder or documentation-style UDID was passed.
    [Arguments]    ${udid}    ${variable_name}
    ${has_lt}=    Run Keyword And Return Status    Should Contain    ${udid}    <
    ${has_gt}=    Run Keyword And Return Status    Should Contain    ${udid}    >
    IF    ${has_lt} or ${has_gt}
        Fail    ${variable_name} still contains < or > after normalization. Received: "${udid}". Use the adb devices first column only, e.g. emulator-5554 or R58T318T3PP
    END
    ${lower}=    Convert To Lower Case    ${udid}
    IF    '${lower}' == 'serial1' or '${lower}' == 'serial2'
        Fail    ${variable_name} looks like a placeholder (${udid}). Run adb devices and use the real first-column value for each phone.
    END

Open Application On Parallel Device
    [Documentation]    Opens MobilCare on one device with a named Appium session alias and dedicated UiAutomator2 systemPort.
    [Arguments]    ${alias}    ${udid}    ${system_port}
    Open Application    ${APPIUM_SERVER_URL}
    ...    alias=${alias}
    ...    platformName=Android
    ...    appium:automationName=UiAutomator2
    ...    appium:deviceName=${udid}
    ...    appium:udid=${udid}
    ...    appium:systemPort=${system_port}
    ...    appium:appPackage=${APP_PACKAGE}
    ...    appium:appActivity=${APP_ACTIVITY}
    ...    appium:appWaitDuration=60000
    ...    appium:appWaitForLaunch=${TRUE}
    ...    appium:autoGrantPermissions=${TRUE}
    ...    appium:noReset=${TRUE}
    ...    appium:newCommandTimeout=300
    Switch Application    ${alias}
    Wait Until Keyword Succeeds    30s    2s    Ensure MobilCare Is Foreground

Begin Parallel Two Device Apps
    [Documentation]    Opens MobilCare on two devices (driver then owner). Pass real adb ids, e.g. ``-v PARALLEL_UDID_DRIVER:emulator-5554``.
    Should Not Be Empty    ${PARALLEL_UDID_DRIVER}
    ...    Pass -v PARALLEL_UDID_DRIVER:YOUR_ADB_ID (see adb devices, first column).
    Should Not Be Empty    ${PARALLEL_UDID_OWNER}
    ...    Pass -v PARALLEL_UDID_OWNER:YOUR_ADB_ID (see adb devices, first column).
    ${driver}=    Normalize Parallel Adb Udid    ${PARALLEL_UDID_DRIVER}
    ${owner}=    Normalize Parallel Adb Udid    ${PARALLEL_UDID_OWNER}
    Set Suite Variable    ${PARALLEL_UDID_DRIVER}    ${driver}
    Set Suite Variable    ${PARALLEL_UDID_OWNER}    ${owner}
    Reject Documentation Style Parallel Udid    ${PARALLEL_UDID_DRIVER}    PARALLEL_UDID_DRIVER
    Reject Documentation Style Parallel Udid    ${PARALLEL_UDID_OWNER}    PARALLEL_UDID_OWNER
    Should Not Be Equal    ${driver}    ${owner}
    ...    PARALLEL_UDID_DRIVER and PARALLEL_UDID_OWNER must be different devices.
    Open Application On Parallel Device    ${PARALLEL_ALIAS_DRIVER}    ${driver}    ${PARALLEL_DRIVER_SYSTEM_PORT}
    Open Application On Parallel Device    ${PARALLEL_ALIAS_OWNER}    ${owner}    ${PARALLEL_OWNER_SYSTEM_PORT}
    Switch To Parallel Owner Session

End Parallel Two Device Apps
    [Documentation]    Closes both parallel Appium sessions (driver and owner).
    Run Keyword And Ignore Error    Switch To Parallel Driver Session
    Run Keyword And Ignore Error    Close Application
    Run Keyword And Ignore Error    Switch To Parallel Owner Session
    Run Keyword And Ignore Error    Close Application

Switch To Parallel Driver Session
    [Documentation]    Activates the driver device Appium session.
    Switch Application    ${PARALLEL_ALIAS_DRIVER}
    Wait Until Keyword Succeeds    15s    2s    Ensure MobilCare Is Foreground

Switch To Parallel Owner Session
    [Documentation]    Activates the fleet owner device Appium session.
    Switch Application    ${PARALLEL_ALIAS_OWNER}
    Wait Until Keyword Succeeds    15s    2s    Ensure MobilCare Is Foreground
