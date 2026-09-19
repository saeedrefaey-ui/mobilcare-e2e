*** Settings ***
Documentation    Post-add Verify account dialog — dismiss via X, do not start verification.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${LBL_VERIFY_ACCOUNT_TITLE}    xpath=//android.widget.TextView[@text="${LBL_VERIFY_ACCOUNT}[en]"]
${LBL_VERIFY_ACCOUNT_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_VERIFY_ACCOUNT}[ar]"]
${BTN_CLOSE_VERIFY_DIALOG}    xpath=//android.widget.Button
${BTN_CLOSE_VERIFY_UI}    -android uiautomator:new UiSelector().className("android.widget.Button")
@{VERIFY_DIALOG_TITLE_LOCATORS}    ${LBL_VERIFY_ACCOUNT_TITLE_AR}    ${LBL_VERIFY_ACCOUNT_TITLE}
@{CLOSE_VERIFY_TAP_LOCATORS}    ${BTN_CLOSE_VERIFY_DIALOG}    ${BTN_CLOSE_VERIFY_UI}


*** Keywords ***
Verify Account Dialog Should Be Visible
    [Documentation]    Waits for Verify your account / وثّق حسابك popup.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{VERIFY_DIALOG_TITLE_LOCATORS}    timeout=15s

Dismiss Verify Account Dialog If Shown
    [Documentation]    Taps the dialog X. Does not tap Verify now / وثّق الآن.
    ${shown_ar}=    Run Keyword And Return Status    Wait Until Page Contains    ${LBL_VERIFY_ACCOUNT}[ar]    15s
    ${shown_en}=    Set Variable    ${FALSE}
    IF    not ${shown_ar}
        ${shown_en}=    Run Keyword And Return Status    Wait Until Page Contains    ${LBL_VERIFY_ACCOUNT}[en]    3s
    END
    IF    not ${shown_ar} and not ${shown_en}    RETURN
    Tap First Ready Locator    @{CLOSE_VERIFY_TAP_LOCATORS}    timeout=10s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${LBL_VERIFY_ACCOUNT}[ar]    10s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${LBL_VERIFY_ACCOUNT}[en]    5s
