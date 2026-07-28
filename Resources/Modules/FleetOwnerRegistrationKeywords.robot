*** Settings ***
Documentation    Fleet Owner Registration — flow ID 1 from regression sheet (Arabic path).
Resource    ../PO/SplashError.robot
Resource    ../PO/Onboarding.robot
Resource    ../PO/Login.robot
Resource    ../PO/Verification.robot
Resource    ../PO/Terms.robot
Resource    ../PO/RoleSelection.robot
Resource    ../PO/Name.robot
Resource    ../PO/Tutorial.robot
Resource    ../Common.robot
Resource    ../DataManager.robot

*** Keywords ***
Complete Fleet Owner Registration Flow
    [Documentation]    ID 1 — Fleet Owner | Registration (16 steps).
    ...    Splash → Skip Onboarding → Arabic → Login → OTP → Terms review → Role → Name → Mobilawy tutorial.
    ${phone}=    Get Credential Field For Persona    fleet_owner    phone
    ${otp}=    Get Credential Field For Persona    fleet_owner    otp_hint
    ${display_name}=    Get Credential Field For Persona    fleet_owner    display_name
    Reach Login Screen
    Switch To Arabic Language
    Enter Phone Number And Tap Confirm    ${phone}
    Complete Otp Verification    ${phone}    ${otp}
    Complete Terms With Privacy And Conditions Review
    Select Fleet Owner Role And Confirm
    Enter Display Name And Confirm    ${display_name}
    Mobilawy Tutorial First Step Should Be Visible

Reach Login Screen
    [Documentation]    Steps 1–2 — splash then skip onboarding to sign-in.
    Ensure MobilCare Is Foreground
    Dismiss Splash Error If Shown
    Skip Onboarding If Shown
    Login Screen Should Be Visible
