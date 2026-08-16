*** Settings ***
Documentation    Account type selection after terms (RoleSelectionScreenContent).
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Common/data_manager.robot


*** Variables ***
# Compose ScreenTitle — xpath (UiSelector text is unreliable on Compose).
${LBL_SELECT_ROLE}    xpath=//android.widget.TextView[@text="Select your account type"]
${LBL_SELECT_ROLE_AR}    xpath=//android.widget.TextView[@text="اختار نوع حسابك"]
# Role cards — clickable android.view.View wraps icon (content-desc) + title TextView.
${CARD_FLEET_OWNER}    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="Fleet Owner"]]
${CARD_FLEET_OWNER_AR}    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="صاحب اسطول"]]
${CARD_FLEET_OWNER_TAP}    xpath=//android.widget.TextView[@text="Fleet Owner"]/ancestor::android.view.View[@clickable="true"][1]
${CARD_FLEET_OWNER_AR_TAP}    xpath=//android.widget.TextView[@text="صاحب اسطول"]/ancestor::android.view.View[@clickable="true"][1]
${CARD_DRIVER}    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="Driver"]]
${CARD_DRIVER_AR}    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="سائق فى اسطول"]]
${CARD_SINGLE_OWNER}    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="Single Owner"]]
${CARD_SINGLE_OWNER_AR}    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="سائق حر"]]
# Bottom Confirm button — disabled until a role card is selected.
${BTN_CONFIRM_ROLE}    xpath=//*[@text="Confirm"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM_ROLE_AR}    xpath=//*[@text="تأكيد"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM_ROLE_ENABLED}    xpath=//android.view.View[@clickable="true" and @enabled="true" and .//android.widget.TextView[@text="Confirm"]]
${BTN_CONFIRM_ROLE_ENABLED_AR}    xpath=//android.view.View[@clickable="true" and @enabled="true" and .//android.widget.TextView[@text="تأكيد"]]
# Native MaterialDialog after Confirm — positive is Ok / حسناً (android:id/button1), not Yes.
${DLG_ROLE_CONFIRM_MESSAGE}    xpath=//android.widget.TextView[@resource-id="android:id/message"]
${BTN_ROLE_DIALOG_OK}    id=android:id/button1
${BTN_ROLE_DIALOG_OK_LABEL}    xpath=//android.widget.Button[@resource-id="android:id/button1"]
${BTN_ROLE_DIALOG_OK_TEXT}    xpath=//android.widget.TextView[@text="Ok" or @text="حسناً"]
@{ROLE_TITLE_LOCATORS}    ${LBL_SELECT_ROLE}    ${LBL_SELECT_ROLE_AR}
@{FLEET_OWNER_CARD_TAP_LOCATORS}    ${CARD_FLEET_OWNER_AR}    ${CARD_FLEET_OWNER_AR_TAP}    ${CARD_FLEET_OWNER}    ${CARD_FLEET_OWNER_TAP}
@{CONFIRM_ROLE_TAP_LOCATORS}    ${BTN_CONFIRM_ROLE_AR}    ${BTN_CONFIRM_ROLE}
@{CONFIRM_ROLE_ENABLED_LOCATORS}    ${BTN_CONFIRM_ROLE_ENABLED_AR}    ${BTN_CONFIRM_ROLE_ENABLED}
@{ROLE_DIALOG_SHOWN_LOCATORS}    ${DLG_ROLE_CONFIRM_MESSAGE}    ${BTN_ROLE_DIALOG_OK_LABEL}    ${BTN_ROLE_DIALOG_OK_TEXT}
@{ROLE_DIALOG_CONFIRM_TAP_LOCATORS}    ${BTN_ROLE_DIALOG_OK}    ${BTN_ROLE_DIALOG_OK_LABEL}    ${BTN_ROLE_DIALOG_OK_TEXT}


*** Keywords ***
Role Selection Screen Should Be Visible
    [Documentation]    Waits for role selection screen (EN or AR title).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{ROLE_TITLE_LOCATORS}    timeout=30s

Select Fleet Owner Role
    [Documentation]    Step 12 — tap Fleet Owner role card (Compose clickable row).
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{FLEET_OWNER_CARD_TAP_LOCATORS}    timeout=15s

Select Role By Label
    [Arguments]    ${role_label}
    ${card}=    Set Variable    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="${role_label}"]]
    ${card_tap}=    Set Variable    xpath=//android.widget.TextView[@text="${role_label}"]/ancestor::android.view.View[@clickable="true"][1]
    Tap First Ready Locator    ${card}    ${card_tap}    timeout=15s

Select Role For Persona
    [Documentation]    Taps the role card matching ``persona`` (Credentials.csv → global role labels, AR first).
    [Arguments]    ${persona}
    Ensure MobilCare Is Foreground
    ${roles}=    Get Persona Role Dictionary    ${persona}
    ${card_ar}=    Set Variable    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="${roles}[ar]"]]
    ${card_en}=    Set Variable    xpath=//android.view.View[@clickable="true" and .//android.widget.TextView[@text="${roles}[en]"]]
    ${tap_ar}=    Set Variable    xpath=//android.widget.TextView[@text="${roles}[ar]"]/ancestor::android.view.View[@clickable="true"][1]
    ${tap_en}=    Set Variable    xpath=//android.widget.TextView[@text="${roles}[en]"]/ancestor::android.view.View[@clickable="true"][1]
    Tap First Ready Locator    ${card_ar}    ${tap_ar}    ${card_en}    ${tap_en}    timeout=15s

Wait For Confirm Role Button Enabled
    [Documentation]    Confirm stays disabled until a role card is selected.
    Wait For Any Locator    @{CONFIRM_ROLE_ENABLED_LOCATORS}    timeout=15s

Tap Confirm On Role Selection Screen
    [Documentation]    Step 13 — tap bottom Confirm / تأكيد on the role screen.
    Ensure MobilCare Is Foreground
    Wait For Confirm Role Button Enabled
    Tap First Ready Locator    @{CONFIRM_ROLE_TAP_LOCATORS}    timeout=15s

Confirm Role Selection Dialog
    [Documentation]    Step 14 — native confirmation popup (Ok / حسناً on android:id/button1).
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{ROLE_DIALOG_SHOWN_LOCATORS}    timeout=15s
    IF    not ${shown}
        Fail    Role confirmation dialog did not appear after tapping Confirm.
    END
    Tap First Ready Locator    @{ROLE_DIALOG_CONFIRM_TAP_LOCATORS}    timeout=10s

Select Fleet Owner Role And Confirm
    [Documentation]    Steps 12–14 — select Fleet Owner, confirm on screen, accept dialog.
    Role Selection Screen Should Be Visible
    Select Fleet Owner Role
    Tap Confirm On Role Selection Screen
    Confirm Role Selection Dialog

Select Role And Confirm
    [Arguments]    ${role_label}
    Role Selection Screen Should Be Visible
    Select Role By Label    ${role_label}
    Tap Confirm On Role Selection Screen
    Confirm Role Selection Dialog

Select Role For Persona And Confirm
    [Documentation]    Select role from ``persona``, tap Confirm, accept confirmation dialog.
    [Arguments]    ${persona}
    Role Selection Screen Should Be Visible
    Select Role For Persona    ${persona}
    Tap Confirm On Role Selection Screen
    Confirm Role Selection Dialog
