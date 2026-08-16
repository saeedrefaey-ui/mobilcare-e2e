*** Settings ***
Documentation    View vehicle screen — plate title, mileage update modal.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    MileageDialogPage.robot


*** Variables ***
${BTN_MILEAGE_FIELD}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[en]" or @text="${LBL_CURRENT_MILEAGE}[ar]"]/ancestor::*[@clickable="true"][1]


*** Keywords ***
View Vehicle Screen Should Be Visible For Plate
    [Documentation]    Header shows plate; vehicle name and mileage fields present.
    [Arguments]    ${license_plate}
    Ensure MobilCare Is Foreground
    Wait Until Page Contains    ${license_plate}    30s
    Wait For Any Locator    ${BTN_MILEAGE_FIELD}    timeout=15s

Open Mileage Field On View Vehicle
    [Documentation]    Taps current mileage on view-vehicle to open update modal.
    Tap When Ready    ${BTN_MILEAGE_FIELD}    10s
    Mileage Dialog Should Be Visible

Update Mileage On View Vehicle
    [Documentation]    Opens mileage modal, enters value, confirms.
    [Arguments]    ${mileage}
    Open Mileage Field On View Vehicle
    Complete Mileage Dialog Entry    ${mileage}

Mileage On View Vehicle Should Be
    [Documentation]    Asserts updated mileage appears on view-vehicle screen.
    [Arguments]    ${mileage}
    Ensure MobilCare Is Foreground
    Wait Until Page Contains    ${mileage}    20s
