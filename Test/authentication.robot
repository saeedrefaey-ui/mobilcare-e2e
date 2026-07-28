*** Settings ***
Documentation    Full authentication flows — require device, APK, and valid test accounts.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../Resources/Common.robot
Resource    ../Resources/Modules/AuthenticationKeywords.robot

*** Test Cases ***
Verify Fleet Owner Can Sign In With Valid Phone And Otp
    [Documentation]    MC-101 — login, OTP, role selection, terms, fleet owner home.
    [Tags]    regression    android    authentication    fleet_owner    requires_device
    Sign In As Persona With Otp And Role    fleet_owner

Verify Driver Can Sign In With Valid Phone And Otp
    [Documentation]    Driver persona end-to-end sign-in.
    [Tags]    regression    android    authentication    driver    requires_device
    Sign In As Persona With Otp And Role    driver

Verify Single Owner Can Sign In With Valid Phone And Otp
    [Documentation]    Single owner persona end-to-end sign-in.
    [Tags]    regression    android    authentication    single_owner    requires_device
    Sign In As Persona With Otp And Role    single_owner
