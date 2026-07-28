*** Settings ***
Documentation    Fleet Owner Registration — flow ID 1 from regression sheet.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../Resources/Common.robot
Resource    ../Resources/Modules/FleetOwnerRegistrationKeywords.robot

*** Test Cases ***
Verify Fleet Owner Registration Flow In Arabic
    [Documentation]    ID 1 | Fleet Owner | Registration — 16 steps including Arabic, terms review, Mobilawy tutorial.
    [Tags]    regression    android    authentication    fleet_owner    requires_device
    Complete Fleet Owner Registration Flow
