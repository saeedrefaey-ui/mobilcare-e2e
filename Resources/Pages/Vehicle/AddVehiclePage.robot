*** Settings ***
Documentation    Add vehicle form — fleet owner and single owner share this screen layout.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    MileageDialogPage.robot
Resource    LookupsPage.robot
Resource    ../Fleet/FleetVehiclesListPage.robot
Resource    ../Common/VerifyAccountDialogPage.robot


*** Variables ***
${LBL_ADD_VEHICLE_TITLE}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[en]"]
${LBL_ADD_VEHICLE_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[ar]"]
${LOC_LICENSE_PLATE_LABEL}    xpath=//android.widget.TextView[@text="${LBL_LICENSE_PLATE}[en]"]
${LOC_LICENSE_PLATE_LABEL_AR}    xpath=//android.widget.TextView[@text="${LBL_LICENSE_PLATE}[ar]"]
${INP_LICENSE_PLATE}    xpath=//android.widget.TextView[@text="${LBL_LICENSE_PLATE}[en]" or @text="${LBL_LICENSE_PLATE}[ar]"]/following-sibling::android.widget.EditText
${INP_LICENSE_PLATE_GENERIC}    xpath=(//android.widget.EditText)[1]
${BTN_VEHICLE_BRAND_FIELD}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_BRAND}[en]" or @text="${LBL_VEHICLE_BRAND}[ar]"]/following-sibling::android.widget.EditText
${BTN_VEHICLE_BRAND_MENU}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_BRAND}[en]" or @text="${LBL_VEHICLE_BRAND}[ar]"]/following-sibling::android.widget.EditText//android.widget.TextView
${BTN_VEHICLE_TYPE_FIELD}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_TYPE}[en]" or @text="${LBL_VEHICLE_TYPE}[ar]"]/following-sibling::android.widget.EditText
${BTN_VEHICLE_TYPE_MENU}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_TYPE}[en]" or @text="${LBL_VEHICLE_TYPE}[ar]"]/following-sibling::android.widget.EditText//android.widget.TextView
@{BRAND_FIELD_TAP_LOCATORS}    ${BTN_VEHICLE_BRAND_FIELD}    ${BTN_VEHICLE_BRAND_MENU}
@{TYPE_FIELD_TAP_LOCATORS}    ${BTN_VEHICLE_TYPE_FIELD}    ${BTN_VEHICLE_TYPE_MENU}
${BTN_MILEAGE_FIELD_ADD}    ${BTN_MILEAGE_FIELD}
${BTN_SAVE_ADD_VEHICLE}    xpath=//android.widget.TextView[@text="${BTN_SAVE}[en]" or @text="${BTN_SAVE}[ar]"]/parent::*[@clickable="true"]
@{ADD_VEHICLE_SCREEN_LOCATORS}    ${LBL_ADD_VEHICLE_TITLE_AR}    ${LBL_ADD_VEHICLE_TITLE}    ${LOC_LICENSE_PLATE_LABEL_AR}    ${LOC_LICENSE_PLATE_LABEL}


*** Keywords ***
Add Vehicle Screen Should Be Visible
    [Documentation]    Waits for add-vehicle screen title and license plate field label.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{ADD_VEHICLE_SCREEN_LOCATORS}    timeout=30s

Enter License Plate Number
    [Documentation]    Fills license plate / vehicle name field on add-vehicle form.
    [Arguments]    ${license_plate}
    ${ready}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${INP_LICENSE_PLATE}    5s
    IF    ${ready}
        Input Text When Ready    ${INP_LICENSE_PLATE}    ${license_plate}
    ELSE
        Input Text When Ready    ${INP_LICENSE_PLATE_GENERIC}    ${license_plate}
    END

Enter Mileage On Add Vehicle Form
    [Documentation]    Opens odometer modal, enters value, taps Confirm / تأكيد.
    [Arguments]    ${mileage}
    Open Mileage Dialog From Field
    Complete Mileage Dialog Entry    ${mileage}

Tap Vehicle Brand Field
    [Documentation]    Opens Vehicle Brand lookup list (label is not clickable — tap the field).
    Tap First Ready Locator    @{BRAND_FIELD_TAP_LOCATORS}    timeout=15s

Tap Vehicle Type Field
    [Documentation]    Opens Vehicle Type lookup list (label is not clickable — tap the field).
    Tap First Ready Locator    @{TYPE_FIELD_TAP_LOCATORS}    timeout=15s

Selected Field Should Display
    [Documentation]    Asserts brand or type value appears on add-vehicle form.
    [Arguments]    ${value}
    Wait Until Page Contains    ${value}    15s

Tap Save On Add Vehicle Form
    [Documentation]    Saves the add-vehicle form. Does not send Back (would leave the form).
    Tap First Ready Locator    ${BTN_SAVE_ADD_VEHICLE}    timeout=15s

Fill Add Vehicle Form
    [Documentation]    Plate, mileage, then brand/type: open list, first row, Save / حفظ.
    [Arguments]    ${license_plate}    ${mileage}
    Enter License Plate Number    ${license_plate}
    Enter Mileage On Add Vehicle Form    ${mileage}
    Tap Vehicle Brand Field
    ${brand_name}=    Select Vehicle Brand From Lookup
    Selected Field Should Display    ${brand_name}
    Tap Vehicle Type Field
    ${type_name}=    Select Vehicle Type From Lookup
    Selected Field Should Display    ${type_name}
    RETURN    ${brand_name}    ${type_name}

Save New Vehicle From Add Form
    [Documentation]    Fill form, save, dismiss verify-account popup, wait for vehicles list.
    [Arguments]    ${license_plate}    ${mileage}
    ${brand_name}    ${type_name}=    Fill Add Vehicle Form    ${license_plate}    ${mileage}
    Tap Save On Add Vehicle Form
    Wait For Post Save Screen
    Dismiss Verify Account Dialog If Shown
    Dismiss Vehicle Added Banner If Shown
    Vehicles List Should Be Visible
    RETURN    ${brand_name}    ${type_name}

Wait For Post Save Screen
    [Documentation]    After Save: verify-account popup, success copy, or vehicles list.
    Wait Until Keyword Succeeds    25s    2s    Post Save Indicator Should Be Visible

Post Save Indicator Should Be Visible
    ${dialog}=    Run Keyword And Return Status    Page Should Contain Text    ${LBL_VERIFY_ACCOUNT}[ar]
    IF    not ${dialog}
        ${dialog}=    Run Keyword And Return Status    Page Should Contain Text    ${LBL_VERIFY_ACCOUNT}[en]
    END
    ${added}=    Run Keyword And Return Status    Page Should Contain Text    ${LBL_VEHICLE_ADDED}[ar]
    IF    not ${added}
        ${added}=    Run Keyword And Return Status    Page Should Contain Text    ${LBL_VEHICLE_ADDED}[en]
    END
    ${tab}=    Run Keyword And Return Status    Page Should Contain Text    ${TAB_FLEET_VEHICLES}[ar]
    IF    not ${tab}
        ${tab}=    Run Keyword And Return Status    Page Should Contain Text    ${TAB_FLEET_VEHICLES}[en]
    END
    ${fab}=    Run Keyword And Return Status    Page Should Contain Element    ${FAB_ADD}
    Should Be True    ${dialog} or ${added} or ${tab} or ${fab}
    ...    Save did not leave the add-vehicle form (duplicate name?).
