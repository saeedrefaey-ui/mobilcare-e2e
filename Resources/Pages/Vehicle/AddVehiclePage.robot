*** Settings ***
Documentation    Add vehicle form — fleet owner and single owner share this screen layout.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
Resource    MileageDialogPage.robot
Resource    LookupsPage.robot
Resource    ../Fleet/FleetVehiclesListPage.robot


*** Variables ***
${LBL_ADD_VEHICLE_TITLE}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[en]"]
${LBL_ADD_VEHICLE_TITLE_AR}    xpath=//android.widget.TextView[@text="${LBL_ADD_VEHICLE}[ar]"]
${LOC_LICENSE_PLATE_LABEL}    xpath=//android.widget.TextView[@text="${LBL_LICENSE_PLATE}[en]"]
${LOC_LICENSE_PLATE_LABEL_AR}    xpath=//android.widget.TextView[@text="${LBL_LICENSE_PLATE}[ar]"]
${INP_LICENSE_PLATE}    xpath=//android.widget.TextView[@text="${LBL_LICENSE_PLATE}[en]" or @text="${LBL_LICENSE_PLATE}[ar]"]/following-sibling::android.widget.EditText
${INP_LICENSE_PLATE_GENERIC}    xpath=(//android.widget.EditText)[1]
${BTN_VEHICLE_BRAND_FIELD}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_BRAND}[en]" or @text="${LBL_VEHICLE_BRAND}[ar]"]/ancestor::*[@clickable="true"][1]
${BTN_VEHICLE_TYPE_FIELD}    xpath=//android.widget.TextView[@text="${LBL_VEHICLE_TYPE}[en]" or @text="${LBL_VEHICLE_TYPE}[ar]"]/ancestor::*[@clickable="true"][1]
${BTN_MILEAGE_FIELD_ADD}    xpath=//android.widget.TextView[@text="${LBL_CURRENT_MILEAGE}[en]" or @text="${LBL_CURRENT_MILEAGE}[ar]"]/ancestor::*[@clickable="true"][1]
${BTN_SAVE_ADD_VEHICLE}    xpath=//*[@text="${BTN_SAVE}[en]" or @text="${BTN_SAVE}[ar]"]/ancestor::*[@clickable="true"][1]
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
    [Documentation]    Opens mileage modal on add form and confirms value.
    [Arguments]    ${mileage}
    Tap When Ready    ${BTN_MILEAGE_FIELD_ADD}    10s
    Complete Mileage Dialog Entry    ${mileage}

Tap Vehicle Brand Field
    [Documentation]    Opens Vehicle Brand lookup list.
    Tap When Ready    ${BTN_VEHICLE_BRAND_FIELD}    10s

Tap Vehicle Type Field
    [Documentation]    Opens Vehicle Type lookup list.
    Tap When Ready    ${BTN_VEHICLE_TYPE_FIELD}    10s

Selected Field Should Display
    [Documentation]    Asserts brand or type value appears on add-vehicle form.
    [Arguments]    ${value}
    Wait Until Page Contains    ${value}    15s

Tap Save On Add Vehicle Form
    [Documentation]    Saves the add-vehicle form.
    Hide Keyboard If Visible
    Tap First Ready Locator    ${BTN_SAVE_ADD_VEHICLE}    timeout=15s

Fill Add Vehicle Form
    [Documentation]    Steps 2–9 — plate, mileage, brand lookup, type lookup.
    [Arguments]    ${license_plate}    ${mileage}    ${brand_name}    ${type_name}
    Enter License Plate Number    ${license_plate}
    Enter Mileage On Add Vehicle Form    ${mileage}
    Tap Vehicle Brand Field
    Select Vehicle Brand From Lookup    ${brand_name}
    Selected Field Should Display    ${brand_name}
    Tap Vehicle Type Field
    Select Vehicle Type From Lookup    ${type_name}
    Selected Field Should Display    ${type_name}

Save New Vehicle From Add Form
    [Documentation]    Step 10 — tap Save; expect return to vehicles list.
    [Arguments]    ${license_plate}    ${mileage}    ${brand_name}    ${type_name}
    Fill Add Vehicle Form    ${license_plate}    ${mileage}    ${brand_name}    ${type_name}
    Tap Save On Add Vehicle Form
    Vehicles List Should Be Visible
