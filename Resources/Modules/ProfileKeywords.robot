*** Settings ***
Documentation   Driver Leaving The Team.
Resource    ../Pages/Home/HomePage.robot
Resource    ../Pages/Profile/ProfilePage.robot
Resource    ../Modules/LoginKeywords.robot
Resource    ../Pages/Profile/Menu.robot
Resource    ../Common/data_manager.robot


*** Keywords ***
Driver Leave The Team
    [Documentation]    Login as driver, open menu, leave team; skip Start trip / invitation home check.
    Login As Persona    driver    assert_home=${False}
    Opening The Menu
    Open Driver Profile
    Driver Leaveing The Team 
    Verify Driver Left Team Successfully
    Back To Home Screen Again
    Verify Join Team Button



