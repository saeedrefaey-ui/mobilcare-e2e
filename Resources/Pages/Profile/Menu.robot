*** Settings ***
Documentation    Driver Profile.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${DRIVER_PROFILE_BTN}  xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View[1]/android.view.View[3]


*** Keywords ***
Open Driver Profile
    [Documentation]    Open Driver Profile  
    Click Element   ${DRIVER_PROFILE_BTN}