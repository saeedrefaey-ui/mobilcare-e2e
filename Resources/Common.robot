*** Settings ***
Documentation    Appium session lifecycle and shared wait helpers for MobilCare Android.
Library    AppiumLibrary
Resource    Variables/capabilities/android_caps.robot

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

Wait Until Screen Contains Text
    [Documentation]    Waits until visible page text appears (EN copy; add AR variant in PO if needed).
    [Arguments]    ${text}    ${timeout}=30s
    Wait Until Page Contains    ${text}    ${timeout}

Wait Until Element Is Ready
    [Documentation]    Waits until locator is visible on screen.
    [Arguments]    ${locator}    ${timeout}=30s
    Wait Until Page Contains Element    ${locator}    ${timeout}

Tap When Ready
    [Documentation]    Waits for element then clicks once.
    [Arguments]    ${locator}    ${timeout}=30s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    Click Element    ${locator}

Input Text When Ready
    [Documentation]    Clears and types into a field after it becomes visible.
    [Arguments]    ${locator}    ${text}    ${timeout}=30s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    Clear Text    ${locator}
    Input Text    ${locator}    ${text}

Tap First Ready Locator
    [Documentation]    Clicks the first locator that becomes visible (Compose-safe fallbacks).
    [Arguments]    @{locators}    ${timeout}=30s
    FOR    ${locator}    IN    @{locators}
        ${ready}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${locator}    ${timeout}
        IF    ${ready}
            Click Element    ${locator}
            RETURN
        END
    END
    Fail    None of the locators were ready: @{locators}

Wait For Any Locator
    [Documentation]    Polls until any locator in the list is visible. Pass ``timeout=30s`` after locators.
    [Arguments]    @{locators}    ${timeout}=30s
    Wait Until Keyword Succeeds    ${timeout}    2s    Any Locator Should Be Visible    @{locators}

Any Locator Should Be Visible
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        ${visible}=    Run Keyword And Return Status    Page Should Contain Element    ${locator}
        IF    ${visible}    RETURN
    END
    Fail    None of the locators are visible: @{locators}
