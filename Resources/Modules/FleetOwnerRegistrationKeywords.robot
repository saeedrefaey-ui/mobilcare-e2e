*** Settings ***
Documentation    Fleet Owner Registration — flow ID 1 from regression sheet (Arabic path).
Resource    AuthenticationKeywords.robot
Resource    ../Pages/Authentication/LoginPage.robot
Resource    ../Pages/Authentication/VerificationPage.robot
Resource    ../Pages/Authentication/TermsPage.robot
Resource    ../Pages/Authentication/RoleSelectionPage.robot
Resource    ../Pages/Authentication/NamePage.robot
Resource    ../Pages/Authentication/TutorialPage.robot
Resource    ../Common/language_keywords.robot
Resource    ../Common/data_manager.robot


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
    Complete Post Registration Onboarding
