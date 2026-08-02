*** Settings ***
Documentation    EN/AR language switching for MobilCare authentication screens.
Resource    BasePage.robot
Resource    setup_teardown.robot
Resource    ../Pages/Authentication/LoginPage.robot


*** Keywords ***
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
