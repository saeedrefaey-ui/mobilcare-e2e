*** Settings ***
Documentation    Data registration — full name after role selection (NameScreenContent).
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
# Compose ScreenTitle / subtitle — xpath (UiSelector text is unreliable on Compose).
${LBL_DATA_REGISTRATION}    xpath=//android.widget.TextView[@text="Data Registration"]
${LBL_DATA_REGISTRATION_AR}    xpath=//android.widget.TextView[@text="تسجيل البيانات"]
${LBL_ENTER_NAME_AR}    xpath=//android.widget.TextView[@text="أدخل اسمك"]
${LBL_ENTER_NAME}    xpath=//android.widget.TextView[@text="Enter your name"]
${LBL_FULL_NAME_AR}    xpath=//android.widget.TextView[@text="الإسم بالكامل"]
${LBL_FULL_NAME}    xpath=//android.widget.TextView[@text="Full name"]
# Name field — scoped to this screen (Compose EditText below the full-name label).
${INP_FULL_NAME}    xpath=//android.widget.TextView[@text="الإسم بالكامل" or @text="Full name"]/following::android.widget.EditText[1]
${INP_FULL_NAME_FALLBACK}    xpath=//android.widget.TextView[@text="تسجيل البيانات" or @text="Data Registration"]/following::android.widget.EditText[1]
# Bottom Confirm / تأكيد — disabled until a valid name is entered.
${BTN_CONFIRM_NAME}    xpath=//*[@text="Confirm"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM_NAME_AR}    xpath=//*[@text="تأكيد"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM_NAME_ENABLED}    xpath=//android.view.View[@clickable="true" and @enabled="true" and .//android.widget.TextView[@text="Confirm"]]
${BTN_CONFIRM_NAME_ENABLED_AR}    xpath=//android.view.View[@clickable="true" and @enabled="true" and .//android.widget.TextView[@text="تأكيد"]]
@{NAME_TITLE_LOCATORS}    ${LBL_DATA_REGISTRATION}    ${LBL_DATA_REGISTRATION_AR}
@{NAME_SUBTITLE_LOCATORS}    ${LBL_ENTER_NAME_AR}    ${LBL_ENTER_NAME}    ${LBL_FULL_NAME_AR}    ${LBL_FULL_NAME}
@{CONFIRM_NAME_TAP_LOCATORS}    ${BTN_CONFIRM_NAME_AR}    ${BTN_CONFIRM_NAME}
@{CONFIRM_NAME_ENABLED_LOCATORS}    ${BTN_CONFIRM_NAME_ENABLED_AR}    ${BTN_CONFIRM_NAME_ENABLED}


*** Keywords ***
Name Screen Should Be Visible
    [Documentation]    Waits for data registration / name entry screen (EN or AR).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{NAME_TITLE_LOCATORS}    timeout=30s
    Wait For Any Locator    @{NAME_SUBTITLE_LOCATORS}    timeout=15s

Enter Display Name
    [Arguments]    ${name}
    [Documentation]    Step 15 — type full name into the Compose text field.
    Ensure MobilCare Is Foreground
    ${field}=    Set Variable    ${INP_FULL_NAME}
    ${ready}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${INP_FULL_NAME}    5s
    IF    not ${ready}
        ${field}=    Set Variable    ${INP_FULL_NAME_FALLBACK}
        ${ready}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${field}    5s
        IF    not ${ready}
            ${field}=    Set Variable    xpath=//android.widget.EditText
        END
    END
    Tap When Ready    ${field}    15s
    Input Text When Ready    ${field}    ${name}    15s
    Hide Keyboard If Visible

Wait For Confirm Name Button Enabled
    [Documentation]    Confirm stays disabled until name validation passes.
    Wait For Any Locator    @{CONFIRM_NAME_ENABLED_LOCATORS}    timeout=15s

Tap Confirm On Name Screen
    [Documentation]    Step 16 — submit name (Confirm / تأكيد).
    Ensure MobilCare Is Foreground
    Wait For Confirm Name Button Enabled
    Tap First Ready Locator    @{CONFIRM_NAME_TAP_LOCATORS}    timeout=15s

Enter Display Name And Confirm
    [Arguments]    ${name}
    Name Screen Should Be Visible
    Enter Display Name    ${name}
    Tap Confirm On Name Screen

Complete Name Registration If Shown
    [Arguments]    ${name}
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{NAME_TITLE_LOCATORS}    timeout=10s
    IF    not ${shown}
        RETURN
    END
    Enter Display Name And Confirm    ${name}
