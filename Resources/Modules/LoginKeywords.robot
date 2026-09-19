*** Settings ***
Documentation    Persona-driven login — splash/onboarding, phone, OTP; lands on home for registered users.
Resource    ../Pages/Authentication/SplashErrorPage.robot
Resource    ../Pages/Authentication/OnboardingPage.robot
Resource    ../Pages/Authentication/LoginPage.robot
Resource    ../Pages/Authentication/VerificationPage.robot
Resource    ../Pages/Home/HomePage.robot
Resource    ../Common/language_keywords.robot
Resource    ../Common/data_manager.robot


*** Keywords ***
Reach Login Screen
    [Documentation]    Splash → optional error retry → onboarding skip → Sign in screen.
    Dismiss Splash Error If Shown
    Skip Onboarding If Shown
    Login Screen Should Be Visible

Complete Login Flow For Persona
    [Documentation]    Login for an already-registered ``persona`` (fleet_owner, driver, single_owner).
    ...    Same steps as registration up to OTP; skips terms, role, and name; optionally asserts persona home.
    [Arguments]    ${persona}    ${language}=en    ${assert_home}=${True}
    ${credentials}=    Load Persona Credentials    ${persona}
    Reach Login Screen
    IF    '${language}' == 'ar'
        Switch To Arabic Language
    END
    Enter Phone Number And Tap Confirm    ${credentials}[phone]
    Complete Otp Verification    ${credentials}[phone]    ${credentials}[otp]
    IF    ${assert_home}
        Home Screen Should Be Visible For Persona    ${persona}
    END

Complete Login Flow For Persona In Arabic
    [Documentation]    Shortcut — Arabic UI login path to persona home.
    [Arguments]    ${persona}
    Complete Login Flow For Persona    ${persona}    language=ar

Login As Persona
    [Documentation]    Alias for ``Complete Login Flow For Persona``.
    [Arguments]    ${persona}    ${language}=en    ${assert_home}=${True}
    Complete Login Flow For Persona    ${persona}    language=${language}    assert_home=${assert_home}

Login As Persona In Arabic
    [Documentation]    Alias for ``Complete Login Flow For Persona In Arabic``.
    [Arguments]    ${persona}
    Complete Login Flow For Persona In Arabic    ${persona}
