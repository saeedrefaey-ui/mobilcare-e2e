*** Settings ***
Documentation    MobilCare Android smoke — authentication entry points.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/AuthenticationKeywords.robot


*** Test Cases ***
Verify Login Screen Is Reachable After Splash
    [Documentation]    MC-101 step 1 — splash completes and Sign in screen is shown.
    [Tags]    smoke    android    authentication
    Wait For Login Screen

Verify Login Screen Shows Phone Field And Confirm
    [Documentation]    MC-101 steps 1–2 — phone input and Confirm are present.
    [Tags]    smoke    android    authentication
    Verify Login Screen Has Phone Field And Confirm
