*** Settings ***
Documentation    Driver | Invitations — accept a fleet owner joining invitation from driver home.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/DriverInvitationKeywords.robot


*** Variables ***
${LANGUAGE}    ar


*** Test Cases ***
Accept Driver Invitation
    [Documentation]    Home → accept invitation → side menu empty joining invitations → driver home (AR or EN).
    [Tags]    regression    android    invitation    driver
    Login And Accept Driver Invitation    language=${LANGUAGE}
