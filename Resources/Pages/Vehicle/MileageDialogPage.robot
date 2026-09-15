*** Settings ***
Documentation    Mileage entry dialog — add vehicle and view vehicle screens.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${LBL_MILEAGE_DIALOG_TITLE}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[en]"]
${LBL_MILEAGE_DIALOG_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[ar]"]
${INP_MILEAGE_DIALOG}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[en]" or @text="${LBL_CURRENT_MILEAGE}[ar]"]/following-sibling::android.widget.EditText
${INP_MILEAGE_DIALOG_GENERIC}    xpath=(//android.app.Dialog//android.widget.EditText)[last()]
${BTN_CONFIRM_MILEAGE}    xpath=//*[@text="${BTN_CONFIRM_TEXT}[en]" or @text="${BTN_CONFIRM_TEXT}[ar]"]/ancestor::*[@clickable="true"][1]
@{MILEAGE_DIALOG_LOCATORS}    ${LBL_MILEAGE_DIALOG_TITLE_AR}    ${LBL_MILEAGE_DIALOG_TITLE}    ${INP_MILEAGE_DIALOG_GENERIC}


*** Keywords ***
Mileage Dialog Should Be Visible
    [Documentation]    Waits for current mileage popup (EN or AR title).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{MILEAGE_DIALOG_LOCATORS}    timeout=15s

Enter Mileage In Dialog
    [Documentation]    Types mileage into the dialog field.
    [Arguments]    ${mileage}
    Mileage Dialog Should Be Visible
    ${field}=    Get First Ready Edit Text In Dialog
    Tap When Ready    ${field}    5s
    Input Text When Ready    ${field}    ${mileage}    5s

Get First Ready Edit Text In Dialog
    ${ready}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${INP_MILEAGE_DIALOG}    3s
    IF    ${ready}
        RETURN    ${INP_MILEAGE_DIALOG}
    END
    Wait Until Element Is Ready    ${INP_MILEAGE_DIALOG_GENERIC}    10s
    RETURN    ${INP_MILEAGE_DIALOG_GENERIC}

Confirm Mileage Dialog
    [Documentation]    Taps Confirm / تأكيد on mileage modal.
    Hide Keyboard If Visible
    Tap First Ready Locator    ${BTN_CONFIRM_MILEAGE}    timeout=10s

Complete Mileage Dialog Entry
    [Documentation]    Fill mileage value and confirm the modal.
    [Arguments]    ${mileage}
    Enter Mileage In Dialog    ${mileage}
    Confirm Mileage Dialog
