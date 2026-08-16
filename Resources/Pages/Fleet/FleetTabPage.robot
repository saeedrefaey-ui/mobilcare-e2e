*** Settings ***
Documentation    Fleet owner Fleet tab — vehicles list, empty state, and Add FAB.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    ../Home/FleetOwnerHomePage.robot


*** Variables ***
${LOC_START_ADD_VEHICLE}    xpath=//android.widget.TextView[contains(@text,"${LBL_START_ADD_VEHICLE}[en]")]
${LOC_START_ADD_VEHICLE_AR}    xpath=//android.widget.TextView[contains(@text,"${LBL_START_ADD_VEHICLE}[ar]")]
${BTN_ADD_VEHICLE_EMPTY}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[en]"]/ancestor::*[@clickable="true"][1]
${BTN_ADD_VEHICLE_EMPTY_AR}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[ar]"]/ancestor::*[@clickable="true"][1]
${BTN_ADD_VEHICLE_TEXT}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[en]"]
${BTN_ADD_VEHICLE_TEXT_AR}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[ar]"]
@{FLEET_TAB_SHOWN_LOCATORS}    ${LOC_START_ADD_VEHICLE_AR}    ${LOC_START_ADD_VEHICLE}    ${FAB_ADD}    ${BTN_ADD_VEHICLE_TEXT_AR}    ${BTN_ADD_VEHICLE_TEXT}
@{ADD_VEHICLE_TAP_LOCATORS}    ${FAB_ADD}    ${BTN_ADD_VEHICLE_EMPTY_AR}    ${BTN_ADD_VEHICLE_EMPTY}    ${BTN_ADD_VEHICLE_TEXT_AR}    ${BTN_ADD_VEHICLE_TEXT}


*** Keywords ***
Fleet Tab Should Be Visible
    [Documentation]    Waits for Fleet tab content — empty state, Add FAB, or Add vehicle action.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{FLEET_TAB_SHOWN_LOCATORS}    timeout=30s

Tap Add Vehicle
    [Documentation]    Opens add-vehicle from Fleet tab FAB or empty-state button.
    Ensure MobilCare Is Foreground
    Fleet Tab Should Be Visible
    Tap First Ready Locator    @{ADD_VEHICLE_TAP_LOCATORS}    timeout=15s
