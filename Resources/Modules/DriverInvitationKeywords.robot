*** Settings ***
Documentation    Driver invitation flows — accept a fleet owner joining invitation from driver home.
Resource    LoginKeywords.robot
Resource    ../Pages/DriverInvitations/AcceptInvitationPage.robot
Resource    ../Pages/Navigation/DriverSideMenuPage.robot


*** Keywords ***
Accept Driver Invitation From Home
    [Documentation]    Join team → accept invitation → home → side menu empty invitations → driver home.
    Join Team Button Should Be Visible
    Tap Join Team
    Joining Invitations Tab Should Be Visible
    Invitation Should Be Displayed With Accept And Reject Icons
    Tap Accept Invitation
    Confirm And Cancel Buttons Should Be Visible
    Tap Confirm On Joining Confirmation Dialog
    Tap Back To Home Screen
    Start Your Trip Button Should Be Visible
    Tap Driver Avatar
    Driver Side Menu Should Be Visible
    Invitations And Requests Menu Item Should Be Visible
    Tap Invitations And Requests In Side Menu
    Tap Joining Invitations Tab
    Joining Invitations Empty Placeholder Should Be Visible
    Tap Back On Invitations Screen
    Driver Side Menu Should Be Visible
    Tap Side Menu Back
    Driver Home Should Be Visible

Login And Accept Driver Invitation
    [Documentation]    Login as driver, then accept the pending joining invitation from home.
    [Arguments]    ${language}=en
    Complete Login Flow For Persona    driver    language=${language}
    Accept Driver Invitation From Home
