*** Settings ***
Documentation    First-launch onboarding stories — skip path to login.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
# Compose MobilBaseButton: text on TextView, click target is often the parent View.
${BTN_SKIP_ONBOARDING}    -android uiautomator:new UiSelector().text("Skip Onboarding")
${BTN_SKIP_ONBOARDING_CONTAINS}    -android uiautomator:new UiSelector().textContains("Skip")
${BTN_SKIP_ONBOARDING_XPATH}    xpath=//android.widget.TextView[@text="Skip Onboarding"]
${BTN_SKIP_ONBOARDING_PARENT}    xpath=//*[@text="Skip Onboarding"]/ancestor::*[@clickable="true"][1]
${BTN_SKIP_ONBOARDING_AR}    -android uiautomator:new UiSelector().text("تخطى الشرح")
@{SKIP_ONBOARDING_LOCATORS}    ${BTN_SKIP_ONBOARDING}    ${BTN_SKIP_ONBOARDING_CONTAINS}    ${BTN_SKIP_ONBOARDING_XPATH}    ${BTN_SKIP_ONBOARDING_PARENT}    ${BTN_SKIP_ONBOARDING_AR}
@{SKIP_ONBOARDING_TAP_LOCATORS}    ${BTN_SKIP_ONBOARDING_PARENT}    ${BTN_SKIP_ONBOARDING}    ${BTN_SKIP_ONBOARDING_CONTAINS}    ${BTN_SKIP_ONBOARDING_XPATH}    ${BTN_SKIP_ONBOARDING_AR}


*** Keywords ***
Skip Onboarding If Shown
    [Documentation]    Taps Skip when onboarding carousel is visible; no-op otherwise.
    Ensure MobilCare Is Foreground
    ${shown}=    Run Keyword And Return Status    Wait For Skip Onboarding Button    45s
    IF    ${shown}
        Tap Skip Onboarding Button
    END

Wait For Skip Onboarding Button
    [Arguments]    ${timeout}=45s
    Wait For Any Locator    @{SKIP_ONBOARDING_LOCATORS}    timeout=${timeout}

Tap Skip Onboarding Button
    [Documentation]    Prefer clickable ancestor for Compose rows, then text-based locators.
    Tap First Ready Locator    @{SKIP_ONBOARDING_TAP_LOCATORS}    timeout=10s

Onboarding Screen Should Be Visible
    Wait For Skip Onboarding Button
