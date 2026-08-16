*** Settings ***
Documentation    Persona-driven registration — specify user type; data and role selection follow Credentials.csv.
Resource    AuthenticationKeywords.robot
Resource    ../Pages/Authentication/TermsPage.robot
Resource    ../Pages/Authentication/TutorialPage.robot
Resource    ../Common/language_keywords.robot
Resource    ../Common/data_manager.robot


*** Keywords ***
Complete Full Registration Flow For Persona
    [Documentation]    Full sign-up for ``persona`` (fleet_owner, driver, single_owner).
    ...    Uses phone/otp/display_name from Credentials.csv and selects the matching role card.
    ...    ``language``: en | ar. ``include_terms_review``: open privacy + terms links before accept.
    ...    ``include_post_registration``: notification allow, tutorial video, Mobilawy spotlight (fleet_owner).
    [Arguments]    ${persona}
    ...    ${language}=ar
    ...    ${include_terms_review}=${True}
    ...    ${include_post_registration}=${True}
    ${credentials}=    Load Persona Credentials    ${persona}
    Reach Login Screen
    IF    '${language}' == 'ar'
        Switch To Arabic Language
    END
    Enter Phone Number And Tap Confirm    ${credentials}[phone]
    Complete Otp Verification    ${credentials}[phone]    ${credentials}[otp]
    IF    ${include_terms_review}
        Complete Terms With Privacy And Conditions Review
    ELSE
        Accept Terms If Shown
    END
    Select Role For Persona And Confirm    ${persona}
    Enter Display Name And Confirm    ${credentials}[display_name]
    IF    ${include_post_registration}
        Complete Post Registration Onboarding For Persona    ${persona}
    END

Complete Registration Flow For Persona In Arabic
    [Documentation]    Shortcut — Arabic UI, full terms review, post-registration onboarding.
    [Arguments]    ${persona}
    Complete Full Registration Flow For Persona    ${persona}    language=ar

Register As Persona
    [Documentation]    Alias for ``Complete Full Registration Flow For Persona`` (default Arabic path).
    [Arguments]    ${persona}    ${language}=ar
    Complete Full Registration Flow For Persona    ${persona}    language=${language}
