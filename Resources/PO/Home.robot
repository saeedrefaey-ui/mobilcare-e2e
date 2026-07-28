*** Settings ***
Documentation    Persona home dispatcher — delegates to persona-specific PO files.
Resource    FleetOwnerHome.robot
Resource    DriverHome.robot
Resource    SingleOwnerHome.robot

*** Keywords ***
Home Screen Should Be Visible For Persona
    [Documentation]    Routes home assertion to the PO matching ``persona`` from Credentials.csv.
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
