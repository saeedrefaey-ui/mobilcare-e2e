*** Settings ***
Documentation    Vehicle brand and type lookup picker lists — select first row, then Save.
Library    Collections
Library    String
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${LBL_LOOKUP_SEARCH}    xpath=//android.widget.TextView[@text="${LBL_SEARCH}[en]" or @text="${LBL_SEARCH}[ar]"]
${INP_LOOKUP_SEARCH}    xpath=//android.widget.TextView[@text="${LBL_SEARCH}[en]" or @text="${LBL_SEARCH}[ar]"]/following-sibling::android.widget.EditText
${BTN_SAVE_LOOKUP}    xpath=//android.widget.TextView[@text="${BTN_SAVE}[en]" or @text="${BTN_SAVE}[ar]"]/parent::*[@clickable="true"]
${BTN_SAVE_LOOKUP_TEXT}    xpath=//android.widget.TextView[@text="${BTN_SAVE}[en]" or @text="${BTN_SAVE}[ar]"]
${LOC_LOOKUP_TEXTVIEWS}    xpath=//android.widget.TextView
@{LOOKUP_SCREEN_LOCATORS}    ${LBL_LOOKUP_SEARCH}    ${INP_LOOKUP_SEARCH}
@{SAVE_LOOKUP_TAP_LOCATORS}    ${BTN_SAVE_LOOKUP}    ${BTN_SAVE_LOOKUP_TEXT}
@{LOOKUP_CHROME_TEXTS}    ${LBL_VEHICLE_BRAND}[en]    ${LBL_VEHICLE_BRAND}[ar]    ${LBL_VEHICLE_TYPE}[en]    ${LBL_VEHICLE_TYPE}[ar]
...    ${LBL_SEARCH}[en]    ${LBL_SEARCH}[ar]    ${LBL_SEARCH_HINT}[en]    ${LBL_SEARCH_HINT}[ar]
...    ${BTN_SAVE}[en]    ${BTN_SAVE}[ar]


*** Keywords ***
Lookup Screen Should Be Visible
    [Documentation]    Lookup list is open when Search / بحث is shown (not on the add-vehicle form).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{LOOKUP_SCREEN_LOCATORS}    timeout=20s

Vehicle Brand Lookup Screen Should Be Visible
    [Documentation]    Waits for Vehicle Brand lookup list screen.
    Lookup Screen Should Be Visible

Vehicle Type Lookup Screen Should Be Visible
    [Documentation]    Waits for Vehicle Type lookup list screen.
    Lookup Screen Should Be Visible

Get First Lookup Item Name
    [Documentation]    First list label that is not title, search, hint, or Save.
    @{elements}=    Get Webelements    ${LOC_LOOKUP_TEXTVIEWS}
    FOR    ${el}    IN    @{elements}
        ${text}=    Get Text    ${el}
        ${text}=    Strip String    ${text}
        IF    '${text}' == '${EMPTY}'    CONTINUE
        ${chrome}=    Run Keyword And Return Status    List Should Contain Value    ${LOOKUP_CHROME_TEXTS}    ${text}
        IF    not ${chrome}
            RETURN    ${text}
        END
    END
    Fail    No brand/type row found on lookup list.

Select First Lookup Item
    [Documentation]    Taps the first brand/type row. Returns the row label.
    Lookup Screen Should Be Visible
    ${name}=    Wait Until Keyword Succeeds    20s    2s    Get First Lookup Item Name
    ${row}=    Set Variable    xpath=//android.widget.TextView[@text="${name}"]/parent::*[@clickable="true"]
    ${label}=    Set Variable    xpath=//android.widget.TextView[@text="${name}"]
    ${ui}=    Set Variable    -android uiautomator:new UiSelector().text("${name}")
    Tap First Ready Locator    ${row}    ${label}    ${ui}    timeout=10s
    RETURN    ${name}

Tap Save On Lookup Screen
    [Documentation]    Taps Save / حفظ. Must not send Back — that leaves the list without saving.
    Tap First Ready Locator    @{SAVE_LOOKUP_TAP_LOCATORS}    timeout=15s

Select First Lookup Item And Save
    [Documentation]    Select the first list value and confirm with Save / حفظ.
    ${name}=    Select First Lookup Item
    Tap Save On Lookup Screen
    RETURN    ${name}

Select Vehicle Brand From Lookup
    [Documentation]    On brand lookup: select first value, Save, return the selected name.
    Vehicle Brand Lookup Screen Should Be Visible
    ${name}=    Select First Lookup Item And Save
    RETURN    ${name}

Select Vehicle Type From Lookup
    [Documentation]    On type lookup: select first value, Save, return the selected name.
    Vehicle Type Lookup Screen Should Be Visible
    ${name}=    Select First Lookup Item And Save
    RETURN    ${name}
