*** Settings ***
Documentation    Driver side menu opened from the home avatar — invitations and requests entry.
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot


*** Variables ***
${LBL_SIDE_MENU}    xpath=//android.widget.TextView[@text="Menu"]
${LBL_SIDE_MENU_AR}    xpath=//android.widget.TextView[@text="القائمة"]
@{SIDE_MENU_VISIBLE_LOCATORS}    ${LBL_SIDE_MENU_AR}    ${LBL_SIDE_MENU}
${BTN_MENU_INVITATIONS}    xpath=//android.widget.TextView[@text="Invitations and requests"]/ancestor::*[@clickable="true"][1]
${BTN_MENU_INVITATIONS_AR}    xpath=//android.widget.TextView[@text="الدعوات والطلبات"]/ancestor::*[@clickable="true"][1]
@{MENU_INVITATIONS_LOCATORS}    ${BTN_MENU_INVITATIONS_AR}    ${BTN_MENU_INVITATIONS}
# Header back/close — clickable sibling of the Menu title (EN left / AR right)
${BTN_SIDE_MENU_BACK}    xpath=//android.widget.TextView[@text="Menu"]/preceding-sibling::*[@clickable="true"][1]
${BTN_SIDE_MENU_BACK_AR}    xpath=//android.widget.TextView[@text="القائمة"]/preceding-sibling::*[@clickable="true"][1]
@{SIDE_MENU_BACK_LOCATORS}    ${BTN_SIDE_MENU_BACK_AR}    ${BTN_SIDE_MENU_BACK}


*** Keywords ***
Driver Side Menu Should Be Visible
    [Documentation]    Waits for the driver side menu header (EN or AR).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{SIDE_MENU_VISIBLE_LOCATORS}    timeout=20s

Invitations And Requests Menu Item Should Be Visible
    [Documentation]    Asserts the Invitations and requests row is listed on the side menu.
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{MENU_INVITATIONS_LOCATORS}    timeout=15s

Tap Invitations And Requests In Side Menu
    [Documentation]    Opens Invitations and requests from the driver side menu row.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{MENU_INVITATIONS_LOCATORS}    timeout=15s

Tap Side Menu Back
    [Documentation]    Closes the driver side menu via the header back control.
    Ensure MobilCare Is Foreground
    Tap First Ready Locator    @{SIDE_MENU_BACK_LOCATORS}    timeout=15s
