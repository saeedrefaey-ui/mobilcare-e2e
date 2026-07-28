*** Settings ***
Documentation    Account type selection after terms (Select your account type).
Resource    ../Common.robot

*** Variables ***
${LBL_SELECT_ROLE}    -android uiautomator:new UiSelector().text("Select your account type")
${LBL_SELECT_ROLE_AR}    -android uiautomator:new UiSelector().text("اختار نوع حسابك")
${BTN_CONFIRM_ROLE}    -android uiautomator:new UiSelector().text("Confirm")
${BTN_CONFIRM_ROLE_AR}    -android uiautomator:new UiSelector().text("تأكيد")
${BTN_DIALOG_YES}    -android uiautomator:new UiSelector().text("Yes")
${BTN_DIALOG_OK}    -android uiautomator:new UiSelector().text("Ok")
${BTN_DIALOG_YES_AR}    -android uiautomator:new UiSelector().text("حسنًا")
${LBL_FLEET_OWNER}    -android uiautomator:new UiSelector().text("Fleet Owner")
${LBL_FLEET_OWNER_AR}    -android uiautomator:new UiSelector().text("صاحب اسطول")

*** Keywords ***
Role Selection Screen Should Be Visible
    ${en}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${LBL_SELECT_ROLE}    20s
    IF    not ${en}
        Wait Until Element Is Ready    ${LBL_SELECT_ROLE_AR}    25s
    END

Select Fleet Owner Role
    [Documentation]    Step 12 — select Fleet Owner card.
    ${en}=    Run Keyword And Return Status    Tap When Ready    ${LBL_FLEET_OWNER}    5s
    IF    not ${en}
        Tap When Ready    ${LBL_FLEET_OWNER_AR}
    END

Select Role By Label
    [Arguments]    ${role_label}
    ${locator}=    Set Variable    -android uiautomator:new UiSelector().text("${role_label}")
    Tap When Ready    ${locator}

Tap Confirm Role Selection
    ${en}=    Run Keyword And Return Status    Tap When Ready    ${BTN_CONFIRM_ROLE}    5s
    IF    not ${en}
        Tap When Ready    ${BTN_CONFIRM_ROLE_AR}
    END
    Confirm Role Dialog If Shown

Confirm Role Dialog If Shown
    [Documentation]    Step 14 — confirmation dialog (Yes / Ok / حسنًا).
    ${yes}=    Run Keyword And Return Status    Wait Until Page Contains    Yes    5s
    IF    ${yes}
        Tap When Ready    ${BTN_DIALOG_YES}
        RETURN
    END
    ${ok}=    Run Keyword And Return Status    Wait Until Page Contains    Ok    3s
    IF    ${ok}
        Tap When Ready    ${BTN_DIALOG_OK}
        RETURN
    END
    ${ar}=    Run Keyword And Return Status    Wait Until Page Contains    حسن    3s
    IF    ${ar}
        Tap When Ready    ${BTN_DIALOG_YES_AR}
    END

Select Fleet Owner Role And Confirm
    [Documentation]    Steps 12–14 — select Fleet Owner, confirm, accept dialog.
    Role Selection Screen Should Be Visible
    Select Fleet Owner Role
    Tap Confirm Role Selection

Select Role And Confirm
    [Arguments]    ${role_label}
    Role Selection Screen Should Be Visible
    Select Role By Label    ${role_label}
    Tap Confirm Role Selection
