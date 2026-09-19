*** Settings ***
Documentation    Skip app-wide popups — every check is optional, so flows never fail when a popup is absent.
Resource    ../Pages/Common/ReferralPopupPage.robot
Resource    ../Pages/Common/HotOfferPopupPage.robot
Resource    ../Pages/Common/VerifyAccountDialogPage.robot
Resource    ../Pages/Common/InAppTutorialPage.robot


*** Keywords ***
Dismiss First Shown Popup
    [Documentation]    Closes one popup and reports whether anything was dismissed.
    [Arguments]    ${timeout}=5s
    ${referral}=    Dismiss Referral Popup If Shown    ${timeout}
    IF    ${referral}    RETURN    ${TRUE}
    ${hot_offer}=    Dismiss Hot Offer Popup If Shown    ${timeout}
    RETURN    ${hot_offer}

Skip Popups After Login
    [Documentation]    Popups stack after OTP (referral reminder, then a hot offer card) and hide home
    ...    from the accessibility tree, so close them until none is left.
    [Arguments]    ${timeout}=5s    ${max_popups}=4
    FOR    ${i}    IN RANGE    ${max_popups}
        ${dismissed}=    Dismiss First Shown Popup    ${timeout}
        IF    not ${dismissed}    BREAK
        ${timeout}=    Set Variable    3s
    END
    Dismiss Spotlight Tutorial If Shown

Skip All Known Popups
    [Documentation]    Any screen — referral reminder, hot offer card, verify-account dialog, spotlight tutorials.
    [Arguments]    ${timeout}=5s
    Skip Popups After Login    ${timeout}
    Dismiss Verify Account Dialog If Shown
    Dismiss All Fleet Tutorials If Shown
