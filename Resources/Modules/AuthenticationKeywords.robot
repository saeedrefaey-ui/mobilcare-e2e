*** Settings ***
Documentation    Authentication business flows — splash, onboarding, login, OTP, terms, role, name.
Library    Collections
Resource    ../PO/SplashError.robot
Resource    ../PO/Login.robot
Resource    ../PO/Onboarding.robot
Resource    ../PO/Verification.robot
Resource    ../PO/Terms.robot
Resource    ../PO/RoleSelection.robot
Resource    ../PO/Name.robot
Resource    ../PO/Home.robot
Resource    ../Common.robot
Resource    ../DataManager.robot

*** Keywords ***
Reach Login Screen
    [Documentation]    Splash → optional error retry → onboarding skip → Sign in screen.
    Dismiss Splash Error If Shown
    Skip Onboarding If Shown
    Login Screen Should Be Visible

Sign In With Phone Number
    [Documentation]    Enters phone on login screen and submits Confirm.
    [Arguments]    ${phone}
    Login Screen Should Be Visible
    Enter Phone Number And Tap Confirm    ${phone}

Get Role Label For Persona
    [Documentation]    Maps Credentials.csv ``persona`` to role card label on screen (EN).
    [Arguments]    ${persona}
    ${labels}=    Create Dictionary
    ...    fleet_owner=Fleet Owner
    ...    driver=Driver
    ...    single_owner=Single Owner
    ${label}=    Get From Dictionary    ${labels}    ${persona}
    RETURN    ${label}

Complete Role Selection For Persona If Shown
    [Arguments]    ${persona}
    ${en}=    Run Keyword And Return Status    Wait Until Page Contains    Select your account type    15s
    IF    not ${en}
        ${ar}=    Run Keyword And Return Status    Wait Until Page Contains    اختار نوع حسابك    5s
        IF    not ${ar}
            RETURN
        END
    END
    IF    '${persona}' == 'fleet_owner'
        Select Fleet Owner Role And Confirm
    ELSE
        ${role_label}=    Get Role Label For Persona    ${persona}
        Select Role And Confirm    ${role_label}
    END

Complete Registration After Otp For Persona
    [Documentation]    Post-OTP: Terms → Role → Name (each skipped if already done).
    [Arguments]    ${persona}
    ${display_name}=    Get Credential Field For Persona    ${persona}    display_name
    Accept Terms If Shown
    Complete Role Selection For Persona If Shown    ${persona}
    Complete Name Registration If Shown    ${display_name}

Sign In As Persona With Otp
    [Arguments]    ${persona}
    ${phone}=    Get Credential Field For Persona    ${persona}    phone
    ${otp}=    Get Credential Field For Persona    ${persona}    otp_hint
    Reach Login Screen
    Sign In With Phone Number    ${phone}
    Complete Otp Verification Simple    ${otp}

Sign In As Persona With Otp And Role
    [Arguments]    ${persona}
    ${phone}=    Get Credential Field For Persona    ${persona}    phone
    ${otp}=    Get Credential Field For Persona    ${persona}    otp_hint
    Reach Login Screen
    Sign In With Phone Number    ${phone}
    Complete Otp Verification Simple    ${otp}
    Complete Registration After Otp For Persona    ${persona}
    Home Screen Should Be Visible For Persona    ${persona}

Wait For Login Screen
    Reach Login Screen

Verify Login Screen Has Phone Field And Confirm
    Reach Login Screen
    Login Phone Field And Confirm Should Be Visible
