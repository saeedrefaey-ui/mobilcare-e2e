*** Settings *** 
Documentation    Fleet owner vehicle flows — add, list, view, update mileage (full Vehicles regression scope).
Resource    LoginKeywords.robot
Resource    ../Common/data_manager.robot
Resource    ../Pages/Navigation/BottomNavigationPage.robot
Resource    ../Pages/Fleet/FleetTabPage.robot
Resource    ../Pages/Fleet/FleetVehiclesListPage.robot
Resource    ../Pages/Vehicle/AddVehiclePage.robot
Resource    ../Pages/Vehicle/ViewVehiclePage.robot
Resource    ../Pages/Common/InAppTutorialPage.robot


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
    Save New Vehicle From Add Form
    ...    ${vehicle}[license_plate]
    ...    ${vehicle}[mileage]
    ...    ${vehicle}[brand_name]
    ...    ${vehicle}[type_name]
    RETURN    ${vehicle}

Complete Post Add Vehicle Steps For Fleet Owner
    [Documentation]    Steps 11–16 — dismiss tutorials, open vehicle, update mileage.
    [Arguments]    ${vehicle}
    Dismiss All Fleet Tutorials If Shown
    Tap Fleet Vehicles Tab
    Vehicle With Plate Should Be Visible    ${vehicle}[license_plate]
    Tap Vehicle With Plate    ${vehicle}[license_plate]
    View Vehicle Screen Should Be Visible For Plate    ${vehicle}[license_plate]
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
    Save New Vehicle From Add Form
    ...    ${vehicle}[license_plate]
    ...    ${vehicle}[mileage]
    ...    ${vehicle}[brand_name]
    ...    ${vehicle}[type_name]
    RETURN    ${vehicle}

Reach Add Vehicle Screen For Fleet Owner
    [Documentation]    Alias for ``Login And Open Add Vehicle For Fleet Owner``.
    [Arguments]    ${language}=en
    Login And Open Add Vehicle For Fleet Owner    language=${language}
