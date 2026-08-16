*** Settings ***
Documentation    Fleet owner — login, Fleet tab, open Add vehicle screen.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/FleetOwnerVehicleKeywords.robot


*** Variables ***
${LANGUAGE}    en


*** Test Cases ***
Verify Fleet Owner Can Open Add Vehicle From Fleet Tab
    [Documentation]    Login → Fleet tab → Add vehicle → add-vehicle form visible.
    [Tags]    regression    android    fleet_owner    fleet    vehicle    requires_device    smoke
    Login And Open Add Vehicle For Fleet Owner    language=${LANGUAGE}
