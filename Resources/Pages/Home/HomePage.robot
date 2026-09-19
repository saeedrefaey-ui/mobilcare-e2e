*** Settings ***
Documentation    Persona home dispatcher — delegates to persona-specific home pages.
Resource    ../../Common/BasePage.robot
Resource    FleetOwnerHomePage.robot
Resource    DriverHomePage.robot
Resource    SingleOwnerHomePage.robot


*** Variables ***
${MENU_ICON}           xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]/android.view.View[3]/android.view.View[2]
${JOIN_TEAM_BUTTON}    xpath=//android.widget.TextView[@text="Join team"]


*** Keywords ***
Home Screen Should Be Visible For Persona
    [Documentation]    Routes home assertion to the page matching ``persona`` from Credentials.csv.
    [Arguments]    ${persona}
    IF    '${persona}' == 'fleet_owner'
        Fleet Owner Home Should Be Visible
    ELSE IF    '${persona}' == 'driver'
        Driver Home Should Be Visible
    ELSE IF    '${persona}' == 'single_owner'
        Single Owner Home Should Be Visible
    ELSE
        Fail    Unknown persona: ${persona}
    END

Opening The Menu
    [Documentation]    Tap the home menu / profile placeholder icon after login.
    Wait Until Element Is Ready    ${MENU_ICON}    30s
    Click Element    ${MENU_ICON}

Verify Join Team Button
    [Documentation]    Verify button appear in the home screen while no attached team.
    Wait Until Element Is visible    ${JOIN_TEAM_BUTTON}    30s
    Element Should Be Visible    ${JOIN_TEAM_BUTTON}   