*** Settings ***
Documentation    Fleet owner already on home — Fleet tab → Add vehicle only (no login).
...    Use when the app is open on home (e.g. Arabic UI). Requires ``noReset`` in caps (default).
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/FleetOwnerVehicleKeywords.robot


*** Test Cases ***
Navigate To Fleet Tab And Tap Add Vehicle From Home
    [Documentation]    From fleet owner home (AR or EN), tap Fleet bottom tab then Add vehicle.
    [Tags]    regression    android    fleet_owner    fleet    vehicle    requires_device    navigation
    Navigate To Fleet Tab And Tap Add Vehicle

Open Add Vehicle Screen From Arabic Home
    [Documentation]    Same navigation plus assert add-vehicle form is visible.
    [Tags]    regression    android    fleet_owner    fleet    vehicle    requires_device    navigation
    Open Add Vehicle From Fleet Tab For Fleet Owner
