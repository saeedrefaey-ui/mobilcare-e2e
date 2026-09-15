*** Settings ***
Documentation    Vehicle brand and type lookup picker lists.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${LBL_LOOKUP_BRAND_TITLE}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_BRAND}[en]"]
${LBL_LOOKUP_BRAND_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_BRAND}[ar]"]
${LBL_LOOKUP_TYPE_TITLE}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_TYPE}[en]"]
${LBL_LOOKUP_TYPE_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_TYPE}[ar]"]
${BTN_SAVE_LOOKUP}    xpath=//*[@text="${BTN_SAVE}[en]" or @text="${BTN_SAVE}[ar]"]/ancestor::*[@clickable="true"][1]
@{LOOKUP_BRAND_TITLE_LOCATORS}    ${LBL_LOOKUP_BRAND_TITLE_AR}    ${LBL_LOOKUP_BRAND_TITLE}
@{LOOKUP_TYPE_TITLE_LOCATORS}    ${LBL_LOOKUP_TYPE_TITLE_AR}    ${LBL_LOOKUP_TYPE_TITLE}


*** Keywords ***
Vehicle Brand Lookup Screen Should Be Visible
    [Documentation]    Waits for Vehicle Brand lookup list screen.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{LOOKUP_BRAND_TITLE_LOCATORS}    timeout=20s

Vehicle Type Lookup Screen Should Be Visible
    [Documentation]    Waits for Vehicle Type lookup list screen.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{LOOKUP_TYPE_TITLE_LOCATORS}    timeout=20s

Select Lookup Item By Name
    [Documentation]    Taps a brand or type row by visible name.
    [Arguments]    ${name}
    ${item}=    Set Variable    xpath=//android.widget.TextView[@text="${name}"]/ancestor::*[@clickable="true"][1]
    ${text_only}=    Set Variable    xpath=//android.widget.TextView[@text="${name}"]
    Tap First Ready Locator    ${item}    ${text_only}    timeout=15s

Tap Save On Lookup Screen
    [Documentation]    Saves selected brand or type on lookup screen.
    Hide Keyboard If Visible
    Tap First Ready Locator    ${BTN_SAVE_LOOKUP}    timeout=15s

Select Vehicle Brand From Lookup
    [Arguments]    ${brand_name}
    Vehicle Brand Lookup Screen Should Be Visible
    Select Lookup Item By Name    ${brand_name}
    Tap Save On Lookup Screen

Select Vehicle Type From Lookup
    [Arguments]    ${type_name}
    Vehicle Type Lookup Screen Should Be Visible
    Select Lookup Item By Name    ${type_name}
    Tap Save On Lookup Screen
