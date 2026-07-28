*** Settings ***
Documentation    In-app tutorial spotlight — Mobilawy Points first step after registration.
Resource    ../Common.robot

*** Variables ***
${LBL_MOBILAWY_POINTS}    -android uiautomator:new UiSelector().text("Mobilawy Points")
${LBL_MOBILAWY_POINTS_AR}    -android uiautomator:new UiSelector().textContains("Mobilawy")

*** Keywords ***
Mobilawy Tutorial First Step Should Be Visible
    [Documentation]    Step 16 — validate tutorial starts on Mobilawy Points.
    ${en}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${LBL_MOBILAWY_POINTS}    45s
    IF    not ${en}
        Wait Until Element Is Ready    ${LBL_MOBILAWY_POINTS_AR}    15s
    END
