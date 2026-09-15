*** Settings ***
Documentation    View vehicle screen — plate title, mileage update modal.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    MileageDialogPage.robot


*** Variables ***
${BTN_VIEW_MILEAGE_FIELD}    ${BTN_MILEAGE_FIELD}


*** Keywords ***
View Vehicle Screen Should Be Visible For Plate
    [Documentation]    Header shows plate; vehicle name and mileage fields present.
    [Arguments]    ${license_plate}
    Ensure MobilCare Is Foreground
    Wait Until Page Contains    ${license_plate}    30s
    Wait For Any Locator    ${BTN_VIEW_MILEAGE_FIELD}    timeout=15s

View Vehicle Data Should Match
    [Documentation]    Asserts plate, mileage, brand, and type on the view-vehicle screen.
    [Arguments]    ${license_plate}    ${mileage}    ${brand_name}    ${type_name}
    View Vehicle Screen Should Be Visible For Plate    ${license_plate}
    Wait Until Page Contains    ${mileage}    15s
    Wait Until Page Contains    ${brand_name}    15s
    Wait Until Page Contains    ${type_name}    15s

Open Mileage Field On View Vehicle
    [Documentation]    Taps odometer on view-vehicle to open update modal.
    Open Mileage Dialog From Field

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
