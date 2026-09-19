*** Settings ***
Documentation    Joining invitations screen — driver accepts a fleet owner invitation from the home CTA.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../Home/DriverHomePage.robot


*** Variables ***
# Driver home CTA card: "Join team" (${LBL_JOIN_TEAM} from DriverHomePage) / "Send join request from here"
${LBL_JOIN_TEAM_HINT}    xpath=//android.widget.TextView[@text="Send join request from here"]
${LBL_JOIN_TEAM_HINT_AR}    xpath=//android.widget.TextView[@text="انضم لفريق عشان تبدأ نقلاتك"]

# The tappable card is the icon view above the label — the label itself is not clickable
${BTN_JOIN_TEAM}    xpath=//android.widget.TextView[@text="Join team"]/preceding-sibling::*[@clickable="true"][1]
${BTN_JOIN_TEAM_AR}    xpath=//android.widget.TextView[@text="انضم إلى فريق"]/preceding-sibling::*[@clickable="true"][1]

# Last resort — full view-tree path from the device; obfuscated class names break on app rebuilds
${BTN_JOIN_TEAM_TREE}    xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[1]/android.view.View[2]/android.view.View/android.view.View/android.view.View
@{JOIN_TEAM_VISIBLE_LOCATORS}    ${LBL_JOIN_TEAM_AR}    ${LBL_JOIN_TEAM}    ${LBL_JOIN_TEAM_HINT_AR}    ${LBL_JOIN_TEAM_HINT}
@{JOIN_TEAM_TAP_LOCATORS}    ${BTN_JOIN_TEAM_AR}    ${BTN_JOIN_TEAM}    ${BTN_JOIN_TEAM_TREE}

# Invitations and requests screen — joining invitations tab
${TAB_JOINING_INVITATIONS}    xpath=//android.widget.TextView[@text="Joining invitations"]
${TAB_JOINING_INVITATIONS_AR}    xpath=//android.widget.TextView[@text="الدعوات"]
@{JOINING_INVITATIONS_TAB_LOCATORS}    ${TAB_JOINING_INVITATIONS_AR}    ${TAB_JOINING_INVITATIONS}

# Invitation row: inviter name, "+20 …" phone, then the tick and X icon buttons
${LBL_INVITATION_CHIP}    xpath=//android.widget.TextView[@text="invitation"]
# AR chip comes from plurals/invitations — this is the single-invitation form the flow expects
${LBL_INVITATION_CHIP_AR}    xpath=//android.widget.TextView[contains(@text,"دعوة انضمام واحدة")]
${LBL_INVITATION_PHONE}    xpath=//android.widget.TextView[contains(@text,"+")]
${BTN_ACCEPT_INVITATION}    xpath=//android.widget.TextView[contains(@text,"+")]/following::*[@clickable="true"][1]
${BTN_REJECT_INVITATION}    xpath=//android.widget.TextView[contains(@text,"+")]/following::*[@clickable="true"][2]

# Last resort — full view-tree path from the device; obfuscated class names break on app rebuilds
${BTN_ACCEPT_INVITATION_TREE}    xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View[1]
${BTN_REJECT_INVITATION_TREE}    xpath=//androidx.compose.ui.platform.l/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View/android.view.View[2]/android.view.View/android.view.View[2]
@{INVITATION_ROW_LOCATORS}    ${LBL_INVITATION_CHIP_AR}    ${LBL_INVITATION_CHIP}    ${LBL_INVITATION_PHONE}
@{ACCEPT_INVITATION_LOCATORS}    ${BTN_ACCEPT_INVITATION}    ${BTN_ACCEPT_INVITATION_TREE}
@{REJECT_INVITATION_LOCATORS}    ${BTN_REJECT_INVITATION}    ${BTN_REJECT_INVITATION_TREE}

# Joining confirmation dialog raised by the tick — native alert, ids are stable
${BTN_CONFIRM_JOINING}    id=android:id/button1
${BTN_CANCEL_JOINING}    id=android:id/button2
${BTN_CONFIRM_JOINING_LABEL}    xpath=//android.widget.Button[@resource-id="android:id/button1"]
${BTN_CANCEL_JOINING_LABEL}    xpath=//android.widget.Button[@resource-id="android:id/button2"]
@{CONFIRM_JOINING_LOCATORS}    ${BTN_CONFIRM_JOINING}    ${BTN_CONFIRM_JOINING_LABEL}
@{CANCEL_JOINING_LOCATORS}    ${BTN_CANCEL_JOINING}    ${BTN_CANCEL_JOINING_LABEL}

# Joining success dialog — the label sits inside the clickable card
${LBL_JOIN_SUCCESS_TITLE}    xpath=//android.widget.TextView[@text="Congratulations on joining the team!"]
${LBL_JOIN_SUCCESS_TITLE_AR}    xpath=//android.widget.TextView[@text="مبروك الإنضمام لفريق!"]
${LBL_BACK_TO_HOME_SCREEN}    xpath=//android.widget.TextView[@text="Back to home screen"]
${LBL_BACK_TO_HOME_SCREEN_AR}    xpath=//android.widget.TextView[@text="العودة للصفحة الرئيسية"]
${BTN_BACK_TO_HOME_SCREEN}    xpath=//android.widget.TextView[@text="Back to home screen"]/ancestor::*[@clickable="true"][1]
${BTN_BACK_TO_HOME_SCREEN_AR}    xpath=//android.widget.TextView[@text="العودة للصفحة الرئيسية"]/ancestor::*[@clickable="true"][1]
@{JOIN_SUCCESS_DIALOG_LOCATORS}    ${LBL_JOIN_SUCCESS_TITLE_AR}    ${LBL_JOIN_SUCCESS_TITLE}    ${LBL_BACK_TO_HOME_SCREEN_AR}    ${LBL_BACK_TO_HOME_SCREEN}
@{BACK_TO_HOME_TAP_LOCATORS}    ${BTN_BACK_TO_HOME_SCREEN_AR}    ${BTN_BACK_TO_HOME_SCREEN}    ${LBL_BACK_TO_HOME_SCREEN_AR}    ${LBL_BACK_TO_HOME_SCREEN}

# Empty joining-invitations tab after the invitation has been accepted
${LBL_NO_INVITATIONS}    xpath=//android.widget.TextView[contains(@text,"No invitations")]
${LBL_NO_INVITATIONS_AR}    xpath=//android.widget.TextView[contains(@text,"مفيش دعوات")]
${LBL_INVITATIONS_PLACEHOLDER}    xpath=//android.widget.TextView[contains(@text,"it will appear here")]
${LBL_INVITATIONS_PLACEHOLDER_AR}    xpath=//android.widget.TextView[contains(@text,"الدعوات هتظهر هنا")]
@{EMPTY_JOINING_INVITATIONS_LOCATORS}    ${LBL_NO_INVITATIONS_AR}    ${LBL_INVITATIONS_PLACEHOLDER_AR}    ${LBL_NO_INVITATIONS}    ${LBL_INVITATIONS_PLACEHOLDER}

# Header back on Invitations and requests — clickable sibling of the screen title
${BTN_BACK_INVITATIONS}    xpath=//android.widget.TextView[@text="Invitations and requests"]/preceding-sibling::*[@clickable="true"][1]
${BTN_BACK_INVITATIONS_AR}    xpath=//android.widget.TextView[@text="الدعوات والطلبات"]/preceding-sibling::*[@clickable="true"][1]
@{BACK_INVITATIONS_TAP_LOCATORS}    ${BTN_BACK_INVITATIONS_AR}    ${BTN_BACK_INVITATIONS}


*** Keywords ***
Join Team Button Should Be Visible
    [Documentation]    Asserts the driver home Join team CTA card is displayed.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{JOIN_TEAM_VISIBLE_LOCATORS}    timeout=30s

Tap Join Team
    [Documentation]    Opens Invitations and requests from the driver home Join team card.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{JOIN_TEAM_TAP_LOCATORS}    timeout=15s

Joining Invitations Tab Should Be Visible
    [Documentation]    Waits for the Invitations and requests screen on the Joining invitations tab.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{JOINING_INVITATIONS_TAB_LOCATORS}    timeout=30s

Invitation Should Be Displayed With Accept And Reject Icons
    [Documentation]    Asserts an invitation row is listed with both the tick and the X icon.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{INVITATION_ROW_LOCATORS}    timeout=20s
    Any Locator Should Be Visible    @{ACCEPT_INVITATION_LOCATORS}
    Any Locator Should Be Visible    @{REJECT_INVITATION_LOCATORS}

Tap Accept Invitation
    [Documentation]    Taps the tick icon on the listed joining invitation.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{ACCEPT_INVITATION_LOCATORS}    timeout=5s

Confirm And Cancel Buttons Should Be Visible
    [Documentation]    Asserts the joining confirmation dialog shows both Confirm and Cancel.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{CONFIRM_JOINING_LOCATORS}    timeout=20s
    Any Locator Should Be Visible    @{CANCEL_JOINING_LOCATORS}

Tap Confirm On Joining Confirmation Dialog
    [Documentation]    Accepts the invitation by confirming the joining dialog.
    Tap First Ready Locator    @{CONFIRM_JOINING_LOCATORS}    timeout=10s

Tap Back To Home Screen
    [Documentation]    Leaves the joining success dialog through its Back to home screen button.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{JOIN_SUCCESS_DIALOG_LOCATORS}    timeout=30s
    Tap First Ready Locator    @{BACK_TO_HOME_TAP_LOCATORS}    timeout=15s

Start Your Trip Button Should Be Visible
    [Documentation]    Asserts the home CTA changed from Join team to Start your trip after accepting.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{DRIVER_HOME_TRIP_LOCATORS}    timeout=30s

Tap Joining Invitations Tab
    [Documentation]    Selects the Joining invitations tab on Invitations and requests.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{JOINING_INVITATIONS_TAB_LOCATORS}    timeout=15s

Joining Invitations Empty Placeholder Should Be Visible
    [Documentation]    Asserts the joining invitations tab shows only the empty placeholder (EN or AR).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{EMPTY_JOINING_INVITATIONS_LOCATORS}    timeout=20s
    FOR    ${locator}    IN    @{INVITATION_ROW_LOCATORS}
        ${shown}=    Run Keyword And Return Status    Page Should Contain Element    ${locator}
        IF    ${shown}
            Fail    Invitation row is still displayed after accepting: ${locator}
        END
    END

Tap Back On Invitations Screen
    [Documentation]    Leaves Invitations and requests via the header back control; falls back to system back.
    Ensure MobilCare Is Foreground
    ${back}=    Run Keyword And Return Status    Tap First Ready Locator    @{BACK_INVITATIONS_TAP_LOCATORS}    timeout=8s
    IF    not ${back}
        Press Keycode    4
    END
