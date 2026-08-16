*** Settings ***
Documentation    Authentication business flows — splash, onboarding, login, OTP, terms, role, name.
Resource    LoginKeywords.robot
Resource    ../Pages/Authentication/SplashErrorPage.robot
Resource    ../Pages/Authentication/LoginPage.robot
Resource    ../Pages/Authentication/OnboardingPage.robot
Resource    ../Pages/Authentication/VerificationPage.robot
Resource    ../Pages/Authentication/TermsPage.robot
Resource    ../Pages/Authentication/RoleSelectionPage.robot
Resource    ../Pages/Authentication/NamePage.robot
Resource    ../Pages/Home/HomePage.robot
Resource    ../Common/setup_teardown.robot
Resource    ../Common/data_manager.robot


*** Keywords ***
Sign In As Persona And Reach Home
    [Documentation]    Registered user login — phone, OTP, persona home (see LoginKeywords).
    [Arguments]    ${persona}    ${language}=en
    Complete Login Flow For Persona    ${persona}    language=${language}

Sign In With Phone Number
    [Documentation]    Enters phone on login screen and submits Confirm.
    [Arguments]    ${phone}
    Login Screen Should Be Visible
    Enter Phone Number And Tap Confirm    ${phone}

Complete Role Selection For Persona If Shown
    [Documentation]    On role screen, selects the card matching ``persona`` from Credentials.csv.
    [Arguments]    ${persona}
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{ROLE_TITLE_LOCATORS}    timeout=15s
    IF    not ${shown}
        RETURN
    END
    Select Role For Persona And Confirm    ${persona}

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
