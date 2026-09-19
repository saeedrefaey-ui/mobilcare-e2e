*** Settings ***
Documentation    Driver Profile.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${THREE_DOTS_BTN}      xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]/android.view.View/android.view.View[10]/android.view.View[2]
${LEAVE_TEAM_BTN}      xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View[4]
${YES_BTN}             xpath=//android.widget.Button[@resource-id="android:id/button1"]
${CANCEL_BTN}          xpath=//android.widget.Button[@resource-id="android:id/button2"]
${Success_Message}     xpath=//android.widget.TextView[@text="You have successfully left the team"]
${BACK_ARROW1}         xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[3]/android.view.View
${BACK_ARROW2}         xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]

*** Keywords ***

Driver Leaveing The Team 
    [Documentation]    Leaving The Team
    Wait Until Element Is Ready    ${THREE_DOTS_BTN}    10s
    Click Element    ${THREE_DOTS_BTN}
    Wait Until Element Is Ready    ${LEAVE_TEAM_BTN}    10s
    Click Element    ${LEAVE_TEAM_BTN}
    Wait Until Element Is Ready    ${YES_BTN}    5s
    Click Element    ${YES_BTN}

Verify Driver Left Team Successfully
    Wait Until Element Is visible    ${Success_Message}    10s
    ${status_text}=    Get Text    ${Success_Message}
    Should Be Equal    ${status_text}    You have successfully left the team

Back To Home Screen Again
    [Documentation]    Back to home screen
        Click Element    ${Success_Message}
        Wait Until Element Is visible    ${BACK_ARROW1}    5s
        Click Element    ${BACK_ARROW1}
        Sleep    3s
        Wait Until Element Is visible    ${BACK_ARROW2}    5s
        Click Element    ${BACK_ARROW2}

    
