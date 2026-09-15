*** Settings ***
Documentation    Fleet vehicles list — items, inner Vehicles tab, post-save assertions.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    FleetTabPage.robot


*** Variables ***
${TAB_FLEET_VEHICLES_BTN}    xpath=//android.widget.TextView[@text="${TAB_FLEET_VEHICLES}[en]"]/ancestor::*[@clickable="true"][1]
${TAB_FLEET_VEHICLES_BTN_AR}    xpath=//android.widget.TextView[@text="${TAB_FLEET_VEHICLES}[ar]"]/ancestor::*[@clickable="true"][1]
${TAB_FLEET_TEAM_BTN}    xpath=//android.widget.TextView[@text="${TAB_FLEET_TEAM}[en]"]/ancestor::*[@clickable="true"][1]
${TAB_FLEET_TEAM_BTN_AR}    xpath=//android.widget.TextView[@text="${TAB_FLEET_TEAM}[ar]"]/ancestor::*[@clickable="true"][1]
@{FLEET_VEHICLES_TAB_LOCATORS}    ${TAB_FLEET_VEHICLES_BTN_AR}    ${TAB_FLEET_VEHICLES_BTN}
@{FLEET_VEHICLES_LIST_LOCATORS}    ${FAB_ADD}    ${LOC_START_ADD_VEHICLE_AR}    ${LOC_START_ADD_VEHICLE}


*** Keywords ***
Vehicles List Should Be Visible
    [Documentation]    Fleet tab vehicles list — FAB or empty-state (post-save shows list/FAB).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{FLEET_VEHICLES_LIST_LOCATORS}    timeout=30s

Tap Fleet Vehicles Tab
    [Documentation]    Inner Fleet header tab — Vehicles / عربيات.
    Tap First Ready Locator    @{FLEET_VEHICLES_TAB_LOCATORS}    timeout=10s

Vehicle With Plate Should Be Visible
    [Documentation]    Asserts a vehicle row shows the given plate / name.
    [Arguments]    ${license_plate}
    Ensure MobilCare Is Foreground
    Wait Until Page Contains    ${license_plate}    30s

Tap Vehicle With Plate
    [Documentation]    Opens view-vehicle for the given plate number.
    [Arguments]    ${license_plate}
    ${row}=    Set Variable    xpath=//android.widget.TextView[contains(@text,"${license_plate}")]/ancestor::*[@clickable="true"][1]
    ${text}=    Set Variable    xpath=//android.widget.TextView[contains(@text,"${license_plate}")]
    Tap First Ready Locator    ${row}    ${text}    timeout=15s
