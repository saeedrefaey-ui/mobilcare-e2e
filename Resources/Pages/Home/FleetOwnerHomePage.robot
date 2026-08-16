*** Settings ***
Documentation    Fleet owner home — bottom nav, FAB, or empty-state copy (EN/AR).
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    ../Navigation/BottomNavigationPage.robot
Resource    ../Common/InAppTutorialPage.robot
Resource    ../Authentication/TutorialPage.robot


*** Variables ***
${FAB_ADD}    accessibility_id=Add FAB
${LOC_HOME_EMPTY_VEHICLE_EN}    -android uiautomator:new UiSelector().textContains("Start adding vehicle")
${LOC_HOME_EMPTY_VEHICLE_AR}    xpath=//android.widget.TextView[contains(@text,"${LBL_START_ADD_VEHICLE}[ar]")]
${LOC_HOME_ADD_VEHICLE_BTN_AR}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[ar]"]
${LOC_HOME_ADD_VEHICLE_BTN_EN}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[en]"]
@{FLEET_OWNER_HOME_LOCATORS}    ${BTN_HOME_TAB_AR}    ${BTN_HOME_TAB}    ${BTN_FLEET_TAB_AR}    ${BTN_FLEET_TAB}
...    ${FAB_ADD}    ${LOC_HOME_EMPTY_VEHICLE_EN}    ${LOC_HOME_EMPTY_VEHICLE_AR}
...    ${LOC_HOME_ADD_VEHICLE_BTN_AR}    ${LOC_HOME_ADD_VEHICLE_BTN_EN}


*** Keywords ***
Prepare Fleet Owner Home After Login
    [Documentation]    Dismiss post-login overlays (video, Mobilawy, spotlight) before home checks.
    Dismiss Registration Tutorial Video If Shown
    Dismiss All Fleet Tutorials If Shown
    Dismiss Fleet Tab Tutorial Next If Shown

Fleet Owner Home Should Be Visible
    [Documentation]    Waits for logged-in fleet owner shell — bottom nav, FAB, or add-vehicle copy (EN/AR).
    Ensure MobilCare Is Foreground
    Prepare Fleet Owner Home After Login
    Wait For Any Locator    @{FLEET_OWNER_HOME_LOCATORS}    timeout=45s
