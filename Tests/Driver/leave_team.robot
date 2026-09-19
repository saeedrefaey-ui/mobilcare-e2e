*** Settings ***
Documentation    Driver Leave His Team.
Library    Process
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/ProfileKeywords.robot


*** Variables ***


*** Test Cases ***
Verify Driver left the team
    [Documentation]    Driver left the team
    [Tags]    regression    android    driver    leave    team
    Driver Leave The Team