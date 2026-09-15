*** Settings ***
Documentation    Mileage entry dialog — add vehicle and view vehicle screens.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
# add_vehicle form: label is not clickable; tap following EditText / inner كم overlay.
${BTN_MILEAGE_FIELD}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[en]" or @text="${LBL_CURRENT_MILEAGE}[ar]"]/following-sibling::android.widget.EditText
${BTN_MILEAGE_FIELD_INNER}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[en]" or @text="${LBL_CURRENT_MILEAGE}[ar]"]/following-sibling::android.widget.EditText//*[@clickable="true"][1]
${BTN_MILEAGE_KM}    xpath=//android.widget.TextView[@text="${LBL_KM}[en]" or @text="${LBL_KM}[ar]"]/ancestor::*[@clickable="true"][1]
${INP_MILEAGE_DIALOG}    xpath=(//android.widget.EditText[@enabled="true"])[last()]
${BTN_CONFIRM_MILEAGE}    xpath=//android.widget.TextView[@text="${BTN_CONFIRM_TEXT}[en]" or @text="${BTN_CONFIRM_TEXT}[ar]"]/parent::*[@clickable="true"]
${BTN_CONFIRM_MILEAGE_TEXT}    xpath=//android.widget.TextView[@text="${BTN_CONFIRM_TEXT}[en]" or @text="${BTN_CONFIRM_TEXT}[ar]"]
@{MILEAGE_FIELD_TAP_LOCATORS}    ${BTN_MILEAGE_FIELD_INNER}    ${BTN_MILEAGE_FIELD}    ${BTN_MILEAGE_KM}
@{MILEAGE_DIALOG_LOCATORS}    ${BTN_CONFIRM_MILEAGE_TEXT}    ${BTN_CONFIRM_MILEAGE}    ${INP_MILEAGE_DIALOG}
@{CONFIRM_MILEAGE_TAP_LOCATORS}    ${BTN_CONFIRM_MILEAGE}    ${BTN_CONFIRM_MILEAGE_TEXT}


*** Keywords ***
Open Mileage Dialog From Field
    [Documentation]    Taps odometer field (كيلومتر العداد / Current Mileage) to open the mileage modal.
    Tap First Ready Locator    @{MILEAGE_FIELD_TAP_LOCATORS}    timeout=15s
    Mileage Dialog Should Be Visible

Mileage Dialog Should Be Visible
    [Documentation]    Waits for mileage popup Confirm / تأكيد (unique vs add-form Save).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{MILEAGE_DIALOG_LOCATORS}    timeout=15s

Enter Mileage In Dialog
    [Documentation]    Types mileage into the dialog field. Does not hide keyboard (Back dismisses this modal).
    [Arguments]    ${mileage}
    Mileage Dialog Should Be Visible
    Tap When Ready    ${INP_MILEAGE_DIALOG}    10s
    Input Text When Ready    ${INP_MILEAGE_DIALOG}    ${mileage}    5s
    Wait Until Page Contains    ${mileage}    10s

Confirm Mileage Dialog
    [Documentation]    Taps Confirm / تأكيد. Must not send Back — that closes the popup without saving.
    Tap First Ready Locator    @{CONFIRM_MILEAGE_TAP_LOCATORS}    timeout=10s

Complete Mileage Dialog Entry
    [Documentation]    Fill mileage value and confirm the modal.
    [Arguments]    ${mileage}
    Enter Mileage In Dialog    ${mileage}
    Confirm Mileage Dialog
