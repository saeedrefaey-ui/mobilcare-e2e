*** Settings ***
Documentation    Privacy / terms WebView detail screens from terms acceptance.
Resource    ../Common.robot

*** Variables ***
${BTN_BACK}    accessibility_id=Navigate up
${BTN_BACK_XPATH}    xpath=//*[@content-desc="Navigate up" or @content-desc="Back"]

*** Keywords ***
Agreement Screen Should Be Open
    [Documentation]    WebView agreement content loaded (Privacy or Terms).
    Ensure MobilCare Is Foreground
    Wait Until Keyword Succeeds    20s    2s    Agreement Content Should Be Visible

Agreement Content Should Be Visible
    ${webview}=    Run Keyword And Return Status    Page Should Contain Element    xpath=//android.webkit.WebView
    IF    ${webview}    RETURN
    ${back}=    Run Keyword And Return Status    Page Should Contain Element    ${BTN_BACK_XPATH}
    Should Be True    ${back}    Agreement WebView or back control not visible

Go Back From Agreement Screen
    [Documentation]    Returns to terms acceptance screen (Compose header or system back).
    Ensure MobilCare Is Foreground
    ${back}=    Run Keyword And Return Status    Tap When Ready    ${BTN_BACK_XPATH}    3s
    IF    not ${back}
        ${back}=    Run Keyword And Return Status    Tap When Ready    ${BTN_BACK}    3s
    END
    IF    not ${back}
        Press Keycode    4
    END
    Terms Acceptance Screen Should Be Visible Again

Terms Acceptance Screen Should Be Visible Again
    [Documentation]    Asserts we returned to the privacy/terms acceptance screen.
    ${en}=    Run Keyword And Return Status    Wait Until Page Contains Element    xpath=//android.widget.TextView[@text="Your privacy is our priority"]    15s
    IF    not ${en}
        Wait Until Page Contains Element    xpath=//android.widget.TextView[@text="خصوصيتك مهمة بالنسبه لنا"]    15s
    END
