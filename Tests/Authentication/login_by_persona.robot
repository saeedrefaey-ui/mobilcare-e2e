*** Settings ***
Documentation    Persona-driven login — registered users only (phone + OTP → home).
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/LoginKeywords.robot


*** Variables ***
${PERSONA}    fleet_owner
${LANGUAGE}    en


*** Test Cases ***
Verify Login Flow For Persona
    [Documentation]    Login using Credentials.csv row for ``${PERSONA}``; expect home after OTP.
    [Tags]    regression    android    authentication    login    requires_device
    Complete Login Flow For Persona    ${PERSONA}    language=${LANGUAGE}

Verify Fleet Owner Can Login
    [Tags]    regression    android    authentication    fleet_owner    login    requires_device
    Complete Login Flow For Persona    fleet_owner

Verify Driver Can Login
    [Tags]    regression    android    authentication    driver    login    requires_device
    Complete Login Flow For Persona    driver

Verify Single Owner Can Login
    [Tags]    regression    android    authentication    single_owner    login    requires_device
    Complete Login Flow For Persona    single_owner
