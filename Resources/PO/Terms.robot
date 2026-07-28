*** Settings ***
Documentation    Privacy policy and terms acceptance (TermsScreenContent).
Resource    ../Common.robot
Resource    Agreement.robot

*** Variables ***
# Compose ScreenTitle / links — xpath + clickable parent (UiSelector text is unreliable).
${LBL_PRIVACY_TITLE}    xpath=//android.widget.TextView[@text="Your privacy is our priority"]
${LBL_PRIVACY_TITLE_AR}    xpath=//android.widget.TextView[@text="خصوصيتك مهمة بالنسبه لنا"]
${LNK_PRIVACY_POLICY}    xpath=//android.widget.TextView[@text="Privacy policy"]
${LNK_PRIVACY_POLICY_PARENT}    xpath=//*[@text="Privacy policy"]/ancestor::*[@clickable="true"][1]
${LNK_PRIVACY_POLICY_AR}    xpath=//android.widget.TextView[@text="سياسة خصوصية البيانات"]
${LNK_PRIVACY_POLICY_AR_PARENT}    xpath=//*[@text="سياسة خصوصية البيانات"]/ancestor::*[@clickable="true"][1]
${LNK_TERMS}    xpath=//android.widget.TextView[@text="Terms and Conditions"]
${LNK_TERMS_PARENT}    xpath=//*[@text="Terms and Conditions"]/ancestor::*[@clickable="true"][1]
${LNK_TERMS_AR}    xpath=//android.widget.TextView[@text="الشروط والأحكام"]
${LNK_TERMS_AR_PARENT}    xpath=//*[@text="الشروط والأحكام"]/ancestor::*[@clickable="true"][1]
# Compose IconButton checkboxes live in flat ScrollView rows (android.view.View, not CheckBox).
# [1] on preceding-sibling selects the first clickable in document order (privacy row) for both rows — use [last()] for the nearest row IconButton.
${CHK_PRIVACY}    xpath=(//android.widget.TextView[@text="Privacy policy"]/preceding-sibling::android.view.View[@clickable="true"])[last()]
${CHK_PRIVACY_AR}    xpath=(//android.widget.TextView[@text="سياسة خصوصية البيانات"]/preceding-sibling::android.view.View[@clickable="true"])[last()]
${CHK_TERMS}    xpath=(//android.widget.TextView[@text="Terms and Conditions"]/preceding-sibling::android.view.View[@clickable="true"])[last()]
${CHK_TERMS_AR}    xpath=(//android.widget.TextView[@text="الشروط والأحكام"]/preceding-sibling::android.view.View[@clickable="true"])[last()]
${CHK_PRIVACY_FALLBACK}    xpath=(//android.widget.TextView[@text="موافق على"])[1]/preceding-sibling::android.view.View[@clickable="true"][last()]
${CHK_TERMS_FALLBACK}    xpath=(//android.widget.TextView[@text="موافق على"])[2]/preceding-sibling::android.view.View[@clickable="true"][last()]
${CHK_PRIVACY_INDEX}    xpath=(//android.widget.ScrollView/android.view.View[@clickable="true" and not(.//android.widget.TextView)])[1]
${CHK_TERMS_INDEX}    xpath=(//android.widget.ScrollView/android.view.View[@clickable="true" and not(.//android.widget.TextView)])[2]
${BTN_ACCEPT_ENABLED_AR}    xpath=//android.widget.ScrollView/android.view.View[@clickable="true" and @enabled="true" and .//android.widget.TextView[@text="موافق"]]
${BTN_ACCEPT_ENABLED}    xpath=//android.widget.ScrollView/android.view.View[@clickable="true" and @enabled="true" and .//android.widget.TextView[@text="Accept" or @text="Confirm" or @text="تأكيد"]]
${BTN_ACCEPT}    xpath=//android.widget.TextView[@text="Accept"]
${BTN_ACCEPT_PARENT}    xpath=//*[@text="Accept"]/ancestor::*[@clickable="true"][1]
${BTN_ACCEPT_AR}    xpath=//android.widget.TextView[@text="موافق"]
${BTN_ACCEPT_AR_PARENT}    xpath=//*[@text="موافق"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM}    xpath=//android.widget.TextView[@text="Confirm"]
${BTN_CONFIRM_PARENT}    xpath=//*[@text="Confirm"]/ancestor::*[@clickable="true"][1]
${BTN_CONFIRM_AR}    xpath=//android.widget.TextView[@text="تأكيد"]
${BTN_CONFIRM_AR_PARENT}    xpath=//*[@text="تأكيد"]/ancestor::*[@clickable="true"][1]
@{TERMS_TITLE_LOCATORS}    ${LBL_PRIVACY_TITLE}    ${LBL_PRIVACY_TITLE_AR}
@{PRIVACY_LINK_TAP_LOCATORS}    ${LNK_PRIVACY_POLICY_AR}    ${LNK_PRIVACY_POLICY}    ${LNK_PRIVACY_POLICY_AR_PARENT}    ${LNK_PRIVACY_POLICY_PARENT}
@{TERMS_LINK_TAP_LOCATORS}    ${LNK_TERMS_AR}    ${LNK_TERMS}    ${LNK_TERMS_AR_PARENT}    ${LNK_TERMS_PARENT}
@{PRIVACY_CHECKBOX_TAP_LOCATORS}    ${CHK_PRIVACY_AR}    ${CHK_PRIVACY}    ${CHK_PRIVACY_FALLBACK}    ${CHK_PRIVACY_INDEX}
@{TERMS_CHECKBOX_TAP_LOCATORS}    ${CHK_TERMS_AR}    ${CHK_TERMS}    ${CHK_TERMS_FALLBACK}    ${CHK_TERMS_INDEX}
@{ACCEPT_TERMS_TAP_LOCATORS}    ${BTN_ACCEPT_AR_PARENT}    ${BTN_ACCEPT_AR}    ${BTN_CONFIRM_AR_PARENT}    ${BTN_CONFIRM_AR}    ${BTN_ACCEPT_PARENT}    ${BTN_ACCEPT}    ${BTN_CONFIRM_PARENT}    ${BTN_CONFIRM}
@{ACCEPT_TERMS_ENABLED_LOCATORS}    ${BTN_ACCEPT_ENABLED_AR}    ${BTN_ACCEPT_ENABLED}

*** Keywords ***
Terms Screen Should Be Visible
    [Documentation]    Waits for privacy/terms acceptance screen (EN or AR title).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{TERMS_TITLE_LOCATORS}    timeout=30s

Open Privacy Policy Link
    [Documentation]    Opens privacy policy WebView from the terms screen.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{PRIVACY_LINK_TAP_LOCATORS}    timeout=15s
    Agreement Screen Should Be Open

Open Terms And Conditions Link
    [Documentation]    Opens terms and conditions WebView from the terms screen.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{TERMS_LINK_TAP_LOCATORS}    timeout=15s
    Agreement Screen Should Be Open

Tap Privacy Terms Checkbox
    [Documentation]    Taps the privacy-policy acceptance checkbox (Compose IconButton).
    Tap First Ready Locator    @{PRIVACY_CHECKBOX_TAP_LOCATORS}    timeout=10s

Tap Terms And Conditions Checkbox
    [Documentation]    Taps the terms-and-conditions acceptance checkbox (Compose IconButton).
    Tap First Ready Locator    @{TERMS_CHECKBOX_TAP_LOCATORS}    timeout=10s

Accept Terms Checkboxes
    [Documentation]    Step 10 — mark privacy and terms checkboxes as accepted.
    Ensure MobilCare Is Foreground
    Tap Privacy Terms Checkbox
    Tap Terms And Conditions Checkbox

Wait For Accept Button Enabled On Terms Screen
    [Documentation]    Accept stays disabled until both checkboxes are checked.
    Wait For Any Locator    @{ACCEPT_TERMS_ENABLED_LOCATORS}    timeout=15s

Tap Accept On Terms Screen
    [Documentation]    Step 11 — Accept / موافق (Confirm / تأكيد fallbacks).
    Ensure MobilCare Is Foreground
    Wait For Accept Button Enabled On Terms Screen
    Tap First Ready Locator    @{ACCEPT_TERMS_TAP_LOCATORS}    timeout=15s

Complete Terms With Privacy And Conditions Review
    [Documentation]    Steps 8–11 — terms link, back, privacy link, back, checkboxes, accept.
    Terms Screen Should Be Visible
    Open Terms And Conditions Link
    Go Back From Agreement Screen
    Terms Screen Should Be Visible
    Open Privacy Policy Link
    Go Back From Agreement Screen
    Terms Screen Should Be Visible
    Accept Terms Checkboxes
    Tap Accept On Terms Screen

Accept Terms If Shown
    [Documentation]    Short path when review steps not required.
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{TERMS_TITLE_LOCATORS}    timeout=10s
    IF    not ${shown}
        RETURN
    END
    Accept Terms Checkboxes
    Tap Accept On Terms Screen
