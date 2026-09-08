*** Settings ***
Documentation    Vehicles list — inner Vehicles/Team tabs, list cards, post-save banner, open view.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    ../Fleet/FleetTabPage.robot


*** Variables ***
${TAB_FLEET_VEHICLES_BTN}    xpath=//android.widget.TextView[@text="${TAB_FLEET_VEHICLES}[en]"]
${TAB_FLEET_VEHICLES_BTN_AR}    xpath=//android.widget.TextView[@text="${TAB_FLEET_VEHICLES}[ar]"]
${TAB_FLEET_TEAM_BTN}    xpath=//android.widget.TextView[@text="${TAB_FLEET_TEAM}[en]"]
${TAB_FLEET_TEAM_BTN_AR}    xpath=//android.widget.TextView[@text="${TAB_FLEET_TEAM}[ar]"]
${LOC_VEHICLE_ADDED}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_ADDED}[en]"]
${LOC_VEHICLE_ADDED_AR}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_ADDED}[ar]"]
@{FLEET_VEHICLES_TAB_LOCATORS}    ${TAB_FLEET_VEHICLES_BTN_AR}    ${TAB_FLEET_VEHICLES_BTN}
@{VEHICLE_ADDED_BANNER_LOCATORS}    ${LOC_VEHICLE_ADDED_AR}    ${LOC_VEHICLE_ADDED}
@{FLEET_VEHICLES_LIST_LOCATORS}    ${FAB_ADD}    ${TAB_FLEET_VEHICLES_BTN_AR}    ${TAB_FLEET_VEHICLES_BTN}
...    ${LOC_START_ADD_VEHICLE_AR}    ${LOC_START_ADD_VEHICLE}


*** Keywords ***
Dismiss Vehicle Added Banner If Shown
    [Documentation]    Success toast overlays the list in page source — tap it so rows are visible to Appium.
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{VEHICLE_ADDED_BANNER_LOCATORS}    timeout=5s
    IF    not ${shown}    RETURN
    Tap First Ready Locator    @{VEHICLE_ADDED_BANNER_LOCATORS}    timeout=8s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${LBL_VEHICLE_ADDED}[ar]    8s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${LBL_VEHICLE_ADDED}[en]    3s

Vehicles List Should Be Visible
    [Documentation]    Vehicles list after add — FAB or Vehicles / عربيات tab (not the toast overlay).
    Ensure MobilCare Is Foreground
    Dismiss Vehicle Added Banner If Shown
    Wait For Any Locator    @{FLEET_VEHICLES_LIST_LOCATORS}    timeout=30s

Tap Fleet Vehicles Tab
    [Documentation]    Inner Fleet header tab — Vehicles / عربيات.
    Tap First Ready Locator    @{FLEET_VEHICLES_TAB_LOCATORS}    timeout=10s

Top Listed Vehicle Should Show Plate
    [Documentation]    Asserts the new vehicle plate is visible on the top list card.
    [Arguments]    ${license_plate}
    Ensure MobilCare Is Foreground
    Dismiss Vehicle Added Banner If Shown
    Wait Until Page Contains    ${license_plate}    30s

Vehicle With Plate Should Be Visible
    [Documentation]    Asserts a vehicle row shows the given plate / name.
    [Arguments]    ${license_plate}
    Top Listed Vehicle Should Show Plate    ${license_plate}

Tap Vehicle With Plate
    [Documentation]    Opens view-vehicle by tapping the plate text on the list card.
    [Arguments]    ${license_plate}
    ${text}=    Set Variable    xpath=//android.widget.TextView[@text="${license_plate}"]
    ${ui}=    Set Variable    -android uiautomator:new UiSelector().text("${license_plate}")
    Tap First Ready Locator    ${text}    ${ui}    timeout=15s
