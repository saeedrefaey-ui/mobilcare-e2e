*** Settings ***
Documentation    Fleet owner vehicle flows — add, list, view, update mileage (full Vehicles regression scope).
Library    Collections
Resource    LoginKeywords.robot
Resource    ../Common/data_manager.robot
Resource    ../Pages/Navigation/BottomNavigationPage.robot
Resource    ../Pages/Fleet/FleetTabPage.robot
Resource    ../Pages/Vehicle/VehiclesListPage.robot
Resource    ../Pages/Vehicle/AddVehiclePage.robot
Resource    ../Pages/Vehicle/ViewVehiclePage.robot
Resource    ../Pages/Common/InAppTutorialPage.robot
Resource    ../Pages/Common/VerifyAccountDialogPage.robot


*** Keywords ***
Navigate To Fleet Tab And Tap Add Vehicle
    [Documentation]    From home, open Fleet bottom tab and tap Add vehicle (FAB or empty-state button).
    Bottom Navigation Should Be Visible
    Tap Fleet Tab
    Fleet Tab Should Be Visible
    Tap Add Vehicle

Open Add Vehicle From Fleet Tab For Fleet Owner
    [Documentation]    Assumes fleet owner is already logged in on home.
    Navigate To Fleet Tab And Tap Add Vehicle
    Add Vehicle Screen Should Be Visible

Login And Open Add Vehicle For Fleet Owner
    [Documentation]    Login as fleet_owner, navigate to Fleet tab, tap Add vehicle, assert add-vehicle screen.
    [Arguments]    ${language}=en
    Complete Login Flow For Persona    fleet_owner    language=${language}
    Navigate To Fleet Tab And Tap Add Vehicle
    Add Vehicle Screen Should Be Visible

Add Vehicle For Fleet Owner
    [Documentation]    Step 1 — open add vehicle; steps 2–10 fill form and save.
    [Arguments]    ${vehicle_key}=default    ${language}=en
    ${vehicle}=    Load Vehicle Test Data    ${vehicle_key}
    Login And Open Add Vehicle For Fleet Owner    language=${language}
    ${brand_name}    ${type_name}=    Save New Vehicle From Add Form    ${vehicle}[license_plate]    ${vehicle}[mileage]
    Set To Dictionary    ${vehicle}    brand_name=${brand_name}    type_name=${type_name}
    RETURN    ${vehicle}

Complete Post Add Vehicle Steps For Fleet Owner
    [Documentation]    Dismiss verify popup, assert top vehicle, open view, check data, update mileage.
    [Arguments]    ${vehicle}
    Dismiss Verify Account Dialog If Shown
    Dismiss Vehicle Added Banner If Shown
    Dismiss All Fleet Tutorials If Shown
    Vehicles List Should Be Visible
    Top Listed Vehicle Should Show Plate    ${vehicle}[license_plate]
    Tap Vehicle With Plate    ${vehicle}[license_plate]
    View Vehicle Data Should Match
    ...    ${vehicle}[license_plate]
    ...    ${vehicle}[mileage]
    ...    ${vehicle}[brand_name]
    ...    ${vehicle}[type_name]
    Update Mileage On View Vehicle    ${vehicle}[updated_mileage]
    Mileage On View Vehicle Should Be    ${vehicle}[updated_mileage]

Complete Fleet Owner Vehicles Regression Flow
    [Documentation]    Full Fleet Owner | Vehicles scope — add vehicle through mileage update on view screen.
    [Arguments]    ${vehicle_key}=default    ${language}=en
    ${vehicle}=    Add Vehicle For Fleet Owner    ${vehicle_key}    language=${language}
    Complete Post Add Vehicle Steps For Fleet Owner    ${vehicle}

Fill And Save Vehicle On Add Form
    [Documentation]    Steps 2–10 only — assumes add-vehicle screen is already open.
    [Arguments]    ${vehicle_key}=default
    ${vehicle}=    Load Vehicle Test Data    ${vehicle_key}
    ${brand_name}    ${type_name}=    Save New Vehicle From Add Form    ${vehicle}[license_plate]    ${vehicle}[mileage]
    Set To Dictionary    ${vehicle}    brand_name=${brand_name}    type_name=${type_name}
    RETURN    ${vehicle}

Reach Add Vehicle Screen For Fleet Owner
    [Documentation]    Alias for ``Login And Open Add Vehicle For Fleet Owner``.
    [Arguments]    ${language}=en
    Login And Open Add Vehicle For Fleet Owner    language=${language}
