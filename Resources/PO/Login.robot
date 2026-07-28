*** Settings ***
Documentation    Login screen — phone number and Confirm (authentication LoginScreenContent).
Resource    ../Common.robot

*** Variables ***
# Compose ScreenTitle / labels — prefer xpath over UiSelector text (more reliable here).
${LBL_SIGN_IN}    xpath=//android.widget.TextView[@text="Sign in"]
${LBL_SIGN_IN_AR}    xpath=//android.widget.TextView[@text="تسجيل الدخول"]
${LBL_PHONE_SUBTITLE}    xpath=//android.widget.TextView[contains(@text,"phone number")]
${INP_PHONE}    xpath=//android.widget.EditText
${BTN_CONFIRM}    xpath=//android.widget.TextView[@text="Confirm"]
${BTN_CONFIRM_PARENT}    xpath=//*[@text="Confirm"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM_AR}    xpath=//android.widget.TextView[@text="تأكيد"]
${BTN_CONFIRM_AR_PARENT}    xpath=//*[@text="تأكيد"]/ancestor::*[@clickable="true"][1]
${BTN_ARABIC_LANG}    xpath=//android.widget.TextView[@text="عربي"]
${BTN_ARABIC_LANG_PARENT}    xpath=//*[@text="عربي"]/ancestor::*[@clickable="true"][1]
# Native AlertDialog (changeLanguageDialogue) — not Compose; buttons are android:id/button1|button2.
${DLG_CHANGE_LANGUAGE_MESSAGE}    xpath=//android.widget.TextView[@resource-id="android:id/message"]
${BTN_CHANGE_LANGUAGE_CONFIRM}    id=android:id/button1
${BTN_CHANGE_LANGUAGE_CONFIRM_LABEL}    xpath=//android.widget.Button[@resource-id="android:id/button1"]
${BTN_CHANGE_LANGUAGE_DISMISS}    id=android:id/button2
@{LOGIN_TITLE_LOCATORS}    ${LBL_SIGN_IN}    ${LBL_SIGN_IN_AR}
@{ARABIC_SWITCH_TAP_LOCATORS}    ${BTN_ARABIC_LANG_PARENT}    ${BTN_ARABIC_LANG}
@{CONFIRM_TAP_LOCATORS}    ${BTN_CONFIRM_PARENT}    ${BTN_CONFIRM}    ${BTN_CONFIRM_AR_PARENT}    ${BTN_CONFIRM_AR}
@{CHANGE_LANGUAGE_DIALOG_LOCATORS}    ${DLG_CHANGE_LANGUAGE_MESSAGE}    ${BTN_CHANGE_LANGUAGE_CONFIRM_LABEL}
@{CHANGE_LANGUAGE_CONFIRM_TAP_LOCATORS}    ${BTN_CHANGE_LANGUAGE_CONFIRM}    ${BTN_CHANGE_LANGUAGE_CONFIRM_LABEL}

*** Keywords ***
Login Screen Should Be Visible
    [Documentation]    Asserts Sign in screen is shown after splash/onboarding skip path.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{LOGIN_TITLE_LOCATORS}    timeout=30s
    Wait Until Element Is Ready    ${INP_PHONE}    15s

Login Screen Should Be Visible In Arabic
    Ensure MobilCare Is Foreground
    Wait Until Element Is Ready    ${LBL_SIGN_IN_AR}    30s
    Wait Until Element Is Ready    ${INP_PHONE}    15s

Switch To Arabic Language
    [Documentation]    Step 3 — tap عربي and confirm language dialog; app reloads in Arabic.
    Ensure MobilCare Is Foreground
    ${already_ar}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${LBL_SIGN_IN_AR}    3s
    IF    ${already_ar}
        RETURN
    END
    Tap First Ready Locator    @{ARABIC_SWITCH_TAP_LOCATORS}    timeout=15s
    Confirm Language Change Dialog
    Login Screen Should Be Visible In Arabic

Confirm Language Change Dialog
    [Documentation]    Taps native dialog confirm (android:id/button1 — label is uppercased by Android).
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{CHANGE_LANGUAGE_DIALOG_LOCATORS}    timeout=10s
    IF    not ${shown}
        RETURN
    END
    Tap First Ready Locator    @{CHANGE_LANGUAGE_CONFIRM_TAP_LOCATORS}    timeout=10s
    Wait Until Keyword Succeeds    20s    2s    Language Change Dialog Should Be Closed

Language Change Dialog Should Be Closed
    ${open}=    Run Keyword And Return Status    Page Should Contain Element    ${BTN_CHANGE_LANGUAGE_CONFIRM}
    Should Not Be True    ${open}

Enter Phone Number
    [Arguments]    ${phone}
    Ensure MobilCare Is Foreground
    Tap When Ready    ${INP_PHONE}    15s
    Input Text When Ready    ${INP_PHONE}    ${phone}

Tap Confirm On Login
    Hide Keyboard
    Tap First Ready Locator    @{CONFIRM_TAP_LOCATORS}    timeout=15s

Enter Phone Number And Tap Confirm
    [Arguments]    ${phone}
    Enter Phone Number    ${phone}
    Tap Confirm On Login

Login Phone Field And Confirm Should Be Visible
    Wait Until Element Is Ready    ${INP_PHONE}
    Wait For Any Locator    @{CONFIRM_TAP_LOCATORS}    timeout=15s
