*** Settings ***
Documentation    Registration tutorial video and Mobilawy in-app spotlight after sign-up.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    PermissionsPage.robot


*** Variables ***
# Fleet-owner registration video (ExoPlayer / OwnerTutorialScreen) — close via ic_close BackButton.
${VIDEO_TUTORIAL_PLAYER}    xpath=//androidx.media3.ui.PlayerView
${VIDEO_TUTORIAL_SURFACE}    xpath=//android.view.SurfaceView
${BTN_CLOSE_TUTORIAL_VIDEO}    xpath=//android.view.View[@clickable="true" and .//*[@content-desc="icon"]]
${BTN_CLOSE_TUTORIAL_VIDEO_FIRST}    xpath=(//android.view.View[@clickable="true" and .//*[@content-desc="icon"]])[1]
# In-app spotlight — step 1 header (EN / AR).
${LBL_MOBILAWY_POINTS}    xpath=//android.widget.TextView[@text="Mobilawy Points"]
${LBL_MOBILAWY_POINTS_AR}    xpath=//android.widget.TextView[@text="نقاطك مع موبيلاوي"]
${LBL_MOBILAWY_POINTS_PARTIAL}    xpath=//android.widget.TextView[contains(@text,"Mobilawy") or contains(@text,"موبيلاوي")]
@{TUTORIAL_VIDEO_SHOWN_LOCATORS}    ${VIDEO_TUTORIAL_PLAYER}    ${VIDEO_TUTORIAL_SURFACE}
@{TUTORIAL_VIDEO_CLOSE_TAP_LOCATORS}    ${BTN_CLOSE_TUTORIAL_VIDEO}    ${BTN_CLOSE_TUTORIAL_VIDEO_FIRST}
@{MOBILAWY_TUTORIAL_TITLE_LOCATORS}    ${LBL_MOBILAWY_POINTS_AR}    ${LBL_MOBILAWY_POINTS}    ${LBL_MOBILAWY_POINTS_PARTIAL}


*** Keywords ***
Dismiss Registration Tutorial Video If Shown
    [Documentation]    Closes the post-registration fleet-owner tutorial video (X / back skip).
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{TUTORIAL_VIDEO_SHOWN_LOCATORS}    timeout=25s
    IF    not ${shown}
        RETURN
    END
    ${closed}=    Run Keyword And Return Status    Tap First Ready Locator    @{TUTORIAL_VIDEO_CLOSE_TAP_LOCATORS}    timeout=10s
    IF    not ${closed}
        Press Keycode    4
    END
    Wait Until Tutorial Video Is Dismissed

Wait Until Tutorial Video Is Dismissed
    Wait Until Keyword Succeeds    20s    2s    Tutorial Video Should Be Dismissed

Tutorial Video Should Be Dismissed
    ${player}=    Run Keyword And Return Status    Page Should Contain Element    ${VIDEO_TUTORIAL_PLAYER}
    Should Not Be True    ${player}

Mobilawy Tutorial First Step Should Be Visible
    [Documentation]    Step 17 — validate Mobilawy Points spotlight after video + permission prompts.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{MOBILAWY_TUTORIAL_TITLE_LOCATORS}    timeout=45s

Complete Post Registration Onboarding
    [Documentation]    Allow notifications, dismiss tutorial video, assert Mobilawy spotlight.
    Allow Notification Permission If Shown
    Dismiss Registration Tutorial Video If Shown
    Mobilawy Tutorial First Step Should Be Visible
