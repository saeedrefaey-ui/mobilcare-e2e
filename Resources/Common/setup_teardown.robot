*** Settings ***
Documentation    Appium session lifecycle — open, close, and foreground checks for MobilCare Android.
Library    AppiumLibrary
Resource    ../Variables/android_caps.robot
Resource    ../Variables/global_variables.robot


*** Keywords ***
Begin All Tests
    [Documentation]    Opens UiAutomator2 session against ${APPIUM_SERVER_URL} using &{ANDROID_CAPS}.
    Open MobilCare Application

End All Tests
    [Documentation]    Closes all Appium sessions started in this suite.
    Close All Applications

Open MobilCare Application
    Open Application    ${APPIUM_SERVER_URL}    &{ANDROID_CAPS}
    Wait Until Keyword Succeeds    30s    2s    Ensure MobilCare Is Foreground

Ensure MobilCare Is Foreground
    [Documentation]    UiAutomator can report the launcher while MobilCare is visible; activate the app package.
    ${active}=    Run Keyword And Return Status    MobilCare Package Should Be Active
    IF    not ${active}
        Activate Application    ${APP_PACKAGE}
    END
    MobilCare Package Should Be Active

MobilCare Package Should Be Active
    [Documentation]    Confirms UiAutomator page source belongs to MobilCare, not the launcher.
    ${source}=    Get Source
    Should Contain    ${source}    package="${APP_PACKAGE}"
