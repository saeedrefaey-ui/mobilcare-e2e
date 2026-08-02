*** Settings ***
Documentation    Fleet owner home — anchor on shared Add FAB or fleet empty state copy.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
${FAB_ADD}    accessibility_id=Add FAB
${LBL_ADD_VEHICLE}    -android uiautomator:new UiSelector().textContains("Start adding vehicle")


*** Keywords ***
Fleet Owner Home Should Be Visible
    [Documentation]    Waits for fleet owner home indicator (FAB or empty-state copy).
    ${fab}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${FAB_ADD}    45s
    IF    not ${fab}
        Wait Until Element Is Ready    ${LBL_ADD_VEHICLE}    15s
    END
