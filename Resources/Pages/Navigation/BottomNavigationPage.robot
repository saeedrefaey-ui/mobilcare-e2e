*** Settings ***
Documentation    Shared bottom navigation — Home, Fleet, Costs, Map, Services tabs.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${BTN_FLEET_TAB}    xpath=//android.widget.TextView[@text="${TAB_FLEET}[en]"]/ancestor::*[@clickable="true"][1]
${BTN_FLEET_TAB_AR}    xpath=//android.widget.TextView[@text="${TAB_FLEET}[ar]"]/ancestor::*[@clickable="true"][1]
${BTN_FLEET_TAB_TEXT}    xpath=//android.widget.TextView[@text="${TAB_FLEET}[en]"]
${BTN_FLEET_TAB_TEXT_AR}    xpath=//android.widget.TextView[@text="${TAB_FLEET}[ar]"]
${BTN_HOME_TAB}    xpath=//android.widget.TextView[@text="${TAB_HOME}[en]"]/ancestor::*[@clickable="true"][1]
${BTN_HOME_TAB_AR}    xpath=//android.widget.TextView[@text="${TAB_HOME}[ar]"]/ancestor::*[@clickable="true"][1]
@{BOTTOM_NAV_FLEET_TAP_LOCATORS}    ${BTN_FLEET_TAB_AR}    ${BTN_FLEET_TAB}    ${BTN_FLEET_TAB_TEXT_AR}    ${BTN_FLEET_TAB_TEXT}
@{BOTTOM_NAV_HOME_TAP_LOCATORS}    ${BTN_HOME_TAB_AR}    ${BTN_HOME_TAB}
@{BOTTOM_NAV_VISIBLE_LOCATORS}    ${BTN_FLEET_TAB_AR}    ${BTN_FLEET_TAB}    ${BTN_HOME_TAB_AR}    ${BTN_HOME_TAB}


*** Keywords ***
Bottom Navigation Should Be Visible
    [Documentation]    Waits for bottom bar with Home and Fleet tabs (EN or AR).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{BOTTOM_NAV_VISIBLE_LOCATORS}    timeout=30s

Tap Fleet Tab
    [Documentation]    Opens the Fleet tab from the bottom navigation icon.
    Ensure MobilCare Is Foreground
    Dismiss Fleet Tab Tutorial Next If Shown
    Tap First Ready Locator    @{BOTTOM_NAV_FLEET_TAP_LOCATORS}    timeout=15s

Tap Home Tab
    [Documentation]    Opens the Home tab from the bottom navigation icon.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{BOTTOM_NAV_HOME_TAP_LOCATORS}    timeout=15s

Dismiss Fleet Tab Tutorial Next If Shown
    [Documentation]    Fleet bottom-nav spotlight uses a Next button that also opens Fleet.
    ${next}=    Set Variable    xpath=//android.widget.TextView[@text="${BTN_NEXT}[en]" or @text="${BTN_NEXT}[ar]"]/ancestor::*[@clickable="true"][1]
    ${shown}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${next}    3s
    IF    ${shown}
        Tap When Ready    ${next}    5s
    END
