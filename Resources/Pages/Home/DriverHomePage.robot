*** Settings ***
Documentation    Driver home — trip start CTA, join-team CTA, or invitations empty state.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
${BTN_START_TRIP}    xpath=//android.widget.TextView[@text="Start your trip"]
${BTN_START_TRIP_AR}    xpath=//android.widget.TextView[@text="ابدأ نقلتك"]
${LBL_INVITATIONS_EMPTY}    xpath=//android.widget.TextView[contains(@text,"invitation")]
${LBL_JOIN_TEAM}    xpath=//android.widget.TextView[@text="Join team"]
${LBL_JOIN_TEAM_AR}    xpath=//android.widget.TextView[@text="انضم إلى فريق"]
${LBL_HOME_WELCOME}    xpath=//*[@resource-id="home_welcome_text"]
${BTN_DRIVER_AVATAR}    xpath=//*[@resource-id="home_welcome_text"]/preceding-sibling::*[@clickable="true"][1]
@{DRIVER_HOME_TRIP_LOCATORS}    ${BTN_START_TRIP_AR}    ${BTN_START_TRIP}
@{DRIVER_HOME_NO_TEAM_LOCATORS}    ${LBL_JOIN_TEAM_AR}    ${LBL_JOIN_TEAM}    ${LBL_INVITATIONS_EMPTY}


*** Keywords ***
Driver Home Should Be Visible
    [Documentation]    Waits for driver home indicator (EN or AR).
    ${trip}=    Run Keyword And Return Status    Wait For Any Locator    @{DRIVER_HOME_TRIP_LOCATORS}    timeout=45s
    IF    not ${trip}
        Wait For Any Locator    @{DRIVER_HOME_NO_TEAM_LOCATORS}    timeout=15s
    END

Tap Driver Avatar
    [Documentation]    Opens the driver side menu from the home avatar next to the welcome label.
    Ensure MobilCare Is Foreground
    Wait Until Element Is Ready    ${LBL_HOME_WELCOME}    15s
    Tap When Ready    ${BTN_DRIVER_AVATAR}    10s
