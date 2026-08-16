*** Settings ***
Documentation    Fleet Owner | Vehicles — full regression (add, list, view, update mileage).
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/FleetOwnerVehicleKeywords.robot


*** Variables ***
${VEHICLE_KEY}    default
${LANGUAGE}    en


*** Test Cases ***
Verify Fleet Owner Can Add Vehicle And Update Mileage
    [Documentation]    Steps 1–16 — add vehicle form, brand/type lookups, save, list, view, mileage modal.
    [Tags]    regression    android    fleet_owner    fleet    vehicle    requires_device
    Complete Fleet Owner Vehicles Regression Flow    ${VEHICLE_KEY}    language=${LANGUAGE}

Verify Add Vehicle Form Opens From Fleet Tab
    [Documentation]    Step 1 — add vehicle button opens form (requires login).
    [Tags]    regression    android    fleet_owner    fleet    vehicle    requires_device    smoke
    Login And Open Add Vehicle For Fleet Owner    language=${LANGUAGE}

Verify Navigate To Add Vehicle From Home
    [Documentation]    Step 1 only — already logged in on home (Arabic or EN).
    [Tags]    regression    android    fleet_owner    fleet    vehicle    requires_device    navigation
    Navigate To Fleet Tab And Tap Add Vehicle
    Add Vehicle Screen Should Be Visible
