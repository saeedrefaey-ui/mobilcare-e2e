*** Settings ***
Documentation    Native Android runtime permission dialogs (POST_NOTIFICATIONS, etc.).
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
# Android 13+ notification permission — com.google.android.permissioncontroller.
${DLG_NOTIFICATION_PERMISSION}    xpath=//android.widget.TextView[@resource-id="com.android.permissioncontroller:id/permission_message"]
${DLG_NOTIFICATION_PERMISSION_TEXT}    xpath=//android.widget.TextView[contains(@text,"notification") or contains(@text,"إشعار")]
${BTN_ALLOW_NOTIFICATIONS}    id=com.android.permissioncontroller:id/permission_allow_button
${BTN_ALLOW_NOTIFICATIONS_LABEL}    xpath=//android.widget.Button[@resource-id="com.android.permissioncontroller:id/permission_allow_button"]
${BTN_ALLOW_NOTIFICATIONS_TEXT}    xpath=//android.widget.Button[@text="Allow" or contains(@text,"Allow") or contains(@text,"سماح") or contains(@text,"السماح")]
@{NOTIFICATION_PERMISSION_SHOWN_LOCATORS}    ${DLG_NOTIFICATION_PERMISSION}    ${DLG_NOTIFICATION_PERMISSION_TEXT}    ${BTN_ALLOW_NOTIFICATIONS_LABEL}
@{NOTIFICATION_ALLOW_TAP_LOCATORS}    ${BTN_ALLOW_NOTIFICATIONS}    ${BTN_ALLOW_NOTIFICATIONS_LABEL}    ${BTN_ALLOW_NOTIFICATIONS_TEXT}


*** Keywords ***
Allow Notification Permission If Shown
    [Documentation]    Taps Allow on the native notifications runtime dialog when it appears.
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{NOTIFICATION_PERMISSION_SHOWN_LOCATORS}    timeout=20s
    IF    not ${shown}
        RETURN
    END
    Tap First Ready Locator    @{NOTIFICATION_ALLOW_TAP_LOCATORS}    timeout=10s
    Wait Until Notification Permission Dialog Is Closed

Wait Until Notification Permission Dialog Is Closed
    Wait Until Keyword Succeeds    15s    1s    Notification Permission Dialog Should Be Closed

Notification Permission Dialog Should Be Closed
    ${open}=    Run Keyword And Return Status    Page Should Contain Element    ${BTN_ALLOW_NOTIFICATIONS}
    Should Not Be True    ${open}
