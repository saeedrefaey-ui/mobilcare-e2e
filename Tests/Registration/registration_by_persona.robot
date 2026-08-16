*** Settings ***
Documentation    Persona-driven registration — set PERSONA to fleet_owner, driver, or single_owner.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/RegistrationKeywords.robot


*** Variables ***
${PERSONA}    fleet_owner
${LANGUAGE}    ar


*** Test Cases ***
Verify Registration Flow For Persona
    [Documentation]    Full registration using Credentials.csv row for ``${PERSONA}`` and matching role card.
    [Tags]    regression    android    authentication    requires_device    registration
    Complete Full Registration Flow For Persona    ${PERSONA}    language=${LANGUAGE}

Verify Fleet Owner Registration In Arabic
    [Documentation]    Same as default PERSONA=fleet_owner (regression sheet ID 1).
    [Tags]    regression    android    authentication    fleet_owner    requires_device
    Complete Registration Flow For Persona In Arabic    fleet_owner

Verify Driver Registration In Arabic
    [Tags]    regression    android    authentication    driver    requires_device    registration
    Complete Registration Flow For Persona In Arabic    driver

Verify Single Owner Registration In Arabic
    [Tags]    regression    android    authentication    single_owner    requires_device    registration
    Complete Registration Flow For Persona In Arabic    single_owner
