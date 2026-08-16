*** Settings ***
Documentation    Single owner home — vehicles list or add-vehicle prompt.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
${LBL_YOUR_VEHICLES}    -android uiautomator:new UiSelector().text("Your Vehicles")
${LOC_HOME_EMPTY_VEHICLE}    -android uiautomator:new UiSelector().textContains("Add your vehicle")


*** Keywords ***
Single Owner Home Should Be Visible
    [Documentation]    Waits for single-owner home indicator.
    ${vehicles}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${LBL_YOUR_VEHICLES}    45s
    IF    not ${vehicles}
        Wait Until Element Is Ready    ${LOC_HOME_EMPTY_VEHICLE}    15s
    END
