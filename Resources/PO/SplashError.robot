*** Settings ***
Documentation    Splash error screen — network failure after cold start (SplashErrorActivity).
Resource    ../Common.robot

*** Variables ***
${LBL_NO_NETWORK}    -android uiautomator:new UiSelector().textContains("network")
${LBL_CONNECTION_DETAILS}    -android uiautomator:new UiSelector().textContains("check your network")
${BTN_RETRY}    -android uiautomator:new UiSelector().text("Retry")

*** Keywords ***
Splash Error Screen Should Be Visible
    ${network}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${LBL_NO_NETWORK}    10s
    IF    not ${network}
        Wait Until Element Is Ready    ${LBL_CONNECTION_DETAILS}    10s
    END

Tap Retry On Splash Error
    Tap When Ready    ${BTN_RETRY}

Dismiss Splash Error If Shown
    [Documentation]    Taps Retry when splash error is visible; no-op otherwise.
    ${shown}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${BTN_RETRY}    3s
    IF    ${shown}
        Tap Retry On Splash Error
    END
