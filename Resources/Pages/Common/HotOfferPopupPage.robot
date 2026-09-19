*** Settings ***
Documentation    Hot offer card shown after login — dismiss via X, never tap View more.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot


*** Variables ***
${BTN_HOT_OFFER_VIEW_MORE_TEXT}    xpath=//android.widget.TextView[@text="${BTN_HOT_OFFER_VIEW_MORE}[ar]" or @text="${BTN_HOT_OFFER_VIEW_MORE}[en]"]
${BTN_CLOSE_HOT_OFFER}    xpath=//android.view.View[@clickable="true"][.//android.widget.TextView[@text="${BTN_HOT_OFFER_VIEW_MORE}[ar]" or @text="${BTN_HOT_OFFER_VIEW_MORE}[en]"]]/following-sibling::android.view.View[@clickable="true"]
${BTN_CLOSE_HOT_OFFER_SIBLING}    xpath=//android.widget.TextView[@text="${BTN_HOT_OFFER_VIEW_MORE}[ar]" or @text="${BTN_HOT_OFFER_VIEW_MORE}[en]"]/parent::android.view.View/following-sibling::android.view.View[@clickable="true"]
@{HOT_OFFER_POPUP_LOCATORS}    ${BTN_CLOSE_HOT_OFFER}    ${BTN_CLOSE_HOT_OFFER_SIBLING}
@{CLOSE_HOT_OFFER_TAP_LOCATORS}    ${BTN_CLOSE_HOT_OFFER}    ${BTN_CLOSE_HOT_OFFER_SIBLING}


*** Keywords ***
Hot Offer Popup Should Be Visible
    [Documentation]    Hard assert — hot offer card with View more / عرض المزيد is on screen.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{HOT_OFFER_POPUP_LOCATORS}    timeout=15s

Hot Offer Popup Is Displayed
    [Documentation]    Soft check — returns True/False; offers are campaign driven and not always served.
    [Arguments]    ${timeout}=5s
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{HOT_OFFER_POPUP_LOCATORS}    timeout=${timeout}
    RETURN    ${shown}

Dismiss Hot Offer Popup If Shown
    [Documentation]    Taps the card X. Never taps View more / عرض المزيد — that leaves home for the offer screen.
    [Arguments]    ${timeout}=5s
    ${shown}=    Hot Offer Popup Is Displayed    ${timeout}
    IF    not ${shown}    RETURN    ${FALSE}
    Tap First Ready Locator    @{CLOSE_HOT_OFFER_TAP_LOCATORS}    timeout=5s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${BTN_HOT_OFFER_VIEW_MORE}[ar]    10s
    Run Keyword And Return Status    Wait Until Page Does Not Contain    ${BTN_HOT_OFFER_VIEW_MORE}[en]    3s
    RETURN    ${TRUE}
