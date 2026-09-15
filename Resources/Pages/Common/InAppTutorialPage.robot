*** Settings ***
Documentation    In-app spotlight tutorials — skip/dismiss overlays.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${BTN_SKIP_TUTORIAL}    xpath=//*[@text="${BTN_SKIP}[en]" or @text="${BTN_SKIP}[ar]"]/ancestor::*[@clickable="true"][1]
${LBL_ADD_DRIVER_TUTORIAL}    xpath=//android.widget.TextView[contains(@text,"${LBL_ADD_DRIVER_TUTORIAL_HEADER}[en]") or contains(@text,"${LBL_ADD_DRIVER_TUTORIAL_HEADER}[ar]")]
${LBL_TEAM_TAB_TUTORIAL}    xpath=//android.widget.TextView[contains(@text,"${LBL_TEAM_TAB_TUTORIAL_HEADER}[en]") or contains(@text,"${LBL_TEAM_TAB_TUTORIAL_HEADER}[ar]")]


*** Keywords ***
Dismiss Spotlight Tutorial If Shown
    [Documentation]    Taps Skip / تخطى when an in-app tutorial overlay is visible.
    ${shown}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${BTN_SKIP_TUTORIAL}    5s
    IF    ${shown}
        Tap When Ready    ${BTN_SKIP_TUTORIAL}    5s
    END

Dismiss All Fleet Tutorials If Shown
    [Documentation]    Dismisses team-tab and add-driver spotlight tutorials (may appear after first vehicle).
    FOR    ${i}    IN RANGE    3
        Dismiss Spotlight Tutorial If Shown
        Sleep    1s
    END

Add Driver Tutorial Should Be Visible
    [Documentation]    Soft assert — add-driver / team invitation tutorial header.
    ${shown}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${LBL_ADD_DRIVER_TUTORIAL}    10s
    IF    not ${shown}
        ${team}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${LBL_TEAM_TAB_TUTORIAL}    5s
        Should Be True    ${team}    Add Driver / Team tutorial did not appear.
    END
