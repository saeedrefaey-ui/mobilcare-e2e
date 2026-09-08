*** Settings ***
Documentation    Referral reminder popup shown right after login — dismiss via X, never tap Share.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${LBL_REFERRAL_TITLE}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_POPUP}[en]"]
${LBL_REFERRAL_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_POPUP}[ar]"]
${LBL_REFERRAL_REWARD_TEXT}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_REWARD}[en]"]
${LBL_REFERRAL_REWARD_TEXT_AR}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_REWARD}[ar]"]
${BTN_CLOSE_REFERRAL_AR}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_POPUP}[ar]"]/preceding-sibling::android.view.View[@clickable="true"]
${BTN_CLOSE_REFERRAL}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_POPUP}[en]"]/preceding-sibling::android.view.View[@clickable="true"]
${BTN_CLOSE_REFERRAL_REWARD_AR}    xpath=//android.widget.TextView[@text="${LBL_REFERRAL_REWARD}[ar]"]/preceding-sibling::android.view.View[@clickable="true"]
@{REFERRAL_POPUP_LOCATORS}    ${LBL_REFERRAL_TITLE_AR}    ${LBL_REFERRAL_TITLE}
...    ${LBL_REFERRAL_REWARD_TEXT_AR}    ${LBL_REFERRAL_REWARD_TEXT}
@{CLOSE_REFERRAL_TAP_LOCATORS}    ${BTN_CLOSE_REFERRAL_AR}    ${BTN_CLOSE_REFERRAL}    ${BTN_CLOSE_REFERRAL_REWARD_AR}


*** Keywords ***
Referral Popup Should Be Visible
    [Documentation]    Hard assert — referral reminder title or reward line is on screen.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{REFERRAL_POPUP_LOCATORS}    timeout=15s

Referral Popup Is Displayed
    [Documentation]    Soft check — returns True/False; the popup is not guaranteed on every login.
    [Arguments]    ${timeout}=8s
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{REFERRAL_POPUP_LOCATORS}    timeout=${timeout}
    RETURN    ${shown}

Dismiss Referral Popup If Shown
    [Documentation]    Taps the popup X. Never taps Share / انشر الكفاءة — that opens the system share sheet.
    [Arguments]    ${timeout}=8s
    ${shown}=    Referral Popup Is Displayed    ${timeout}
    IF    not ${shown}    RETURN    ${FALSE}
    Tap First Ready Locator    @{CLOSE_REFERRAL_TAP_LOCATORS}    timeout=5s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${LBL_REFERRAL_POPUP}[ar]    10s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${LBL_REFERRAL_POPUP}[en]    3s
    RETURN    ${TRUE}
