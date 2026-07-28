*** Settings ***
Documentation    Data registration — full name after role selection (NameScreenContent).
Resource    ../Common.robot

*** Variables ***
${LBL_DATA_REGISTRATION}    -android uiautomator:new UiSelector().text("Data Registration")
${LBL_DATA_REGISTRATION_AR}    -android uiautomator:new UiSelector().textContains("تسجيل البيانات")
${INP_FULL_NAME}    xpath=//android.widget.EditText
${BTN_CONFIRM_NAME}    -android uiautomator:new UiSelector().text("Confirm")
${BTN_CONFIRM_NAME_AR}    -android uiautomator:new UiSelector().text("تأكيد")

*** Keywords ***
Name Screen Should Be Visible
    ${en}=    Run Keyword And Return Status    Wait Until Element Is Ready    ${LBL_DATA_REGISTRATION}    20s
    IF    not ${en}
        Wait Until Element Is Ready    ${LBL_DATA_REGISTRATION_AR}    25s
    END

Enter Display Name
    [Arguments]    ${name}
    Input Text When Ready    ${INP_FULL_NAME}    ${name}

Tap Confirm On Name Screen
    ${en}=    Run Keyword And Return Status    Tap When Ready    ${BTN_CONFIRM_NAME}    5s
    IF    not ${en}
        Tap When Ready    ${BTN_CONFIRM_NAME_AR}
    END

Enter Display Name And Confirm
    [Arguments]    ${name}
    Name Screen Should Be Visible
    Enter Display Name    ${name}
    Tap Confirm On Name Screen

Complete Name Registration If Shown
    [Arguments]    ${name}
    ${en}=    Run Keyword And Return Status    Wait Until Page Contains    Data Registration    10s
    IF    not ${en}
        ${ar}=    Run Keyword And Return Status    Wait Until Page Contains    تسجيل    5s
        IF    not ${ar}
            RETURN
        END
    END
    Enter Display Name And Confirm    ${name}
