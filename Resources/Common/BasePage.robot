*** Settings ***
Documentation    Reusable wait, tap, and input helpers for MobilCare Compose screens.
Library    AppiumLibrary


*** Keywords ***
Wait Until Screen Contains Text
    [Documentation]    Waits until visible page text appears (EN copy; add AR variant in Pages if needed).
    [Arguments]    ${text}    ${timeout}=30s
    Wait Until Page Contains    ${text}    ${timeout}

Wait Until Element Is Ready
    [Documentation]    Waits until locator is visible on screen.
    [Arguments]    ${locator}    ${timeout}=30s
    Wait Until Page Contains Element    ${locator}    ${timeout}

Hide Keyboard If Visible
    [Documentation]    Hides the on-screen keyboard; ignores errors if it is not shown.
    Run Keyword And Ignore Error    Hide Keyboard

Click Element With Retries
    [Documentation]    Clicks with retries for stale Compose re-renders (element should already be ready).
    [Arguments]    ${locator}    ${max_attempts}=3    ${retry_delay}=0.5s
    FOR    ${i}    IN RANGE    ${max_attempts}
        ${clicked}=    Run Keyword And Return Status    Click Element    ${locator}
        IF    ${clicked}    RETURN
        Sleep    ${retry_delay}
    END
    Fail    Failed to click after ${max_attempts} retries: ${locator}

Click Element With Short Retries
    [Documentation]    Fast click retries for Compose controls that flicker during animation. No long visible wait first — ensure the screen is already on the right step.
    [Arguments]    ${locator}    ${max_attempts}=18    ${delay_s}=0.12
    FOR    ${i}    IN RANGE    ${max_attempts}
        ${clicked}=    Run Keyword And Return Status    Click Element    ${locator}
        IF    ${clicked}    RETURN
        Sleep    ${delay_s}
    END
    Fail    Could not click after ${max_attempts} attempts: ${locator}

Click Element With Stale Retries
    [Documentation]    Waits for locator in hierarchy, then clicks with stale-element retries.
    [Arguments]    ${locator}    ${timeout}=30s    ${max_attempts}=3    ${retry_delay}=0.5s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    Click Element With Retries    ${locator}    ${max_attempts}    ${retry_delay}

Tap When Ready
    [Documentation]    Waits for element then clicks with stale-element retries.
    [Arguments]    ${locator}    ${timeout}=30s
    Click Element With Stale Retries    ${locator}    ${timeout}

Input Text When Ready
    [Documentation]    Clears and types into a field after it becomes visible.
    [Arguments]    ${locator}    ${text}    ${timeout}=30s
    Wait Until Element Is Ready    ${locator}    ${timeout}
    Clear Text    ${locator}
    Input Text    ${locator}    ${text}

Tap First Ready Locator
    [Documentation]    Clicks the first locator that appears, using short retries per candidate (Compose-safe fallbacks).
    [Arguments]    @{locators}    ${timeout}=30s
    FOR    ${locator}    IN    @{locators}
        ${ready}=    Run Keyword And Return Status    Wait Until Page Contains Element    ${locator}    ${timeout}
        IF    ${ready}
            Click Element With Short Retries    ${locator}
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

Pull Down To Refresh Screen
    [Documentation]    Pull-to-refresh gesture on the current screen. Use after offline recovery or list reload flows.
    Swipe By Percent    50    25    50    70
    Sleep    2s
