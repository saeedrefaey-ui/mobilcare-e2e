*** Settings ***
Documentation    Driver home — trip start CTA or invitations empty state.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
${BTN_START_TRIP}    -android uiautomator:new UiSelector().text("Start your trip")
${LBL_INVITATIONS_EMPTY}    -android uiautomator:new UiSelector().textContains("invitation")


*** Keywords ***
Driver Home Should Be Visible
    [Documentation]    Waits for driver home indicator.
    ${trip}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${BTN_START_TRIP}    45s
    IF    not ${trip}
        Wait Until Element Is Ready    ${LBL_INVITATIONS_EMPTY}    15s
    END
