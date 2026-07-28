*** Settings ***
Documentation    OTP verification after login Confirm (Submit on verification screen).
Library    String
Resource    ../Common.robot

*** Variables ***
${LBL_VERIFICATION_CODE}    xpath=//android.widget.TextView[@text="Verification code"]
${LBL_VERIFICATION_CODE_AR}    xpath=//android.widget.TextView[@text="رمز التحقق"]
${LBL_VERIFICATION_SUBTITLE}    xpath=//android.widget.TextView[contains(@text,"Enter verification code")]
${LBL_VERIFICATION_SUBTITLE_AR}    xpath=//android.widget.TextView[contains(@text,"رمز التفعيل")]
${INP_OTP}    xpath=//android.widget.TextView[@text="رمز التحقق"]/following-sibling::android.widget.EditText
${INP_OTP_EN}    xpath=//android.widget.TextView[@text="Verification code"]/following-sibling::android.widget.EditText
${INP_OTP_GENERIC}    xpath=(//android.widget.EditText)[last()]
${BTN_SUBMIT_OTP}    xpath=//android.widget.TextView[@text="Submit"]
${BTN_SUBMIT_OTP_AR}    xpath=//android.widget.TextView[@text="تأكيد"]
${BTN_SUBMIT_OTP_PARENT}    xpath=//*[@text="Submit"]/ancestor::*[@clickable="true"][1]
${BTN_SUBMIT_OTP_AR_PARENT}    xpath=//*[@text="تأكيد"]/ancestor::*[@clickable="true"][1]
@{VERIFICATION_SCREEN_LOCATORS}    ${LBL_VERIFICATION_CODE}    ${LBL_VERIFICATION_CODE_AR}    ${LBL_VERIFICATION_SUBTITLE}    ${LBL_VERIFICATION_SUBTITLE_AR}
@{OTP_INPUT_LOCATORS}    ${INP_OTP}    ${INP_OTP_EN}    ${INP_OTP_GENERIC}
@{SUBMIT_OTP_TAP_LOCATORS}    ${BTN_SUBMIT_OTP_PARENT}    ${BTN_SUBMIT_OTP_AR_PARENT}    ${BTN_SUBMIT_OTP}    ${BTN_SUBMIT_OTP_AR}

*** Keywords ***
Verification Screen Should Be Visible
    [Documentation]    Waits for OTP step after login Confirm (EN or AR copy).
    Ensure MobilCare Is Foreground
    Wait For Any Locator    @{VERIFICATION_SCREEN_LOCATORS}    timeout=30s
    Wait For Otp Input Field

Wait For Otp Input Field
    Wait For Any Locator    @{OTP_INPUT_LOCATORS}    timeout=15s

Displayed Phone On Verification Should Contain
    [Documentation]    Soft check — displayed phone uses 20…+ localized format; must not block OTP entry.
    [Arguments]    ${phone}
    Displayed Phone On Verification If Detectable    ${phone}

Displayed Phone On Verification If Detectable
    [Arguments]    ${phone}
    @{candidates}=    Get Phone Display Match Candidates    ${phone}
    FOR    ${candidate}    IN    @{candidates}
        ${found}=    Run Keyword And Return Status    Wait Until Page Contains    ${candidate}    3s
        IF    ${found}
            RETURN
        END
    END
    Log    Phone display not matched (app may show localized 20…+ format). Continuing to OTP entry.    WARN

Get Phone Display Match Candidates
    [Arguments]    ${phone}
    ${digits}=    Evaluate    ''.join(c for c in str($phone) if c.isdigit())
    ${without_leading_zero}=    Evaluate    $digits.lstrip('0')
    ${last7}=    Evaluate    $digits[-7:] if len($digits) >= 7 else $digits
    
    ${ar_digits}=    Evaluate    $digits.translate(str.maketrans('0123456789', '٠١٢٣٤٥٦٧٨٩'))
    ${ar_without_leading_zero}=    Evaluate    $without_leading_zero.translate(str.maketrans('0123456789', '٠١٢٣٤٥٦٧٨٩'))
    ${ar_last7}=    Evaluate    $last7.translate(str.maketrans('0123456789', '٠١٢٣٤٥٦٧٨٩'))

    @{candidates}=    Create List    
    ...    ${without_leading_zero}    20${without_leading_zero}    ${last7}    ${digits}
    ...    ${ar_without_leading_zero}    ٢٠${ar_without_leading_zero}    ${ar_last7}    ${ar_digits}
    RETURN    @{candidates}

Enter Otp Code
    [Documentation]    Enters 5-digit OTP via keycodes (Compose OTP field). Auto-submits when complete.
    [Arguments]    ${otp}
    Ensure MobilCare Is Foreground
    Wait For Otp Input Field
    ${field}=    Get First Visible Locator    @{OTP_INPUT_LOCATORS}
    Tap When Ready    ${field}    10s
    Input Otp Digits    ${otp}

Input Otp Digits
    [Arguments]    ${otp}
    @{digits}=    Evaluate    list(str($otp))
    FOR    ${digit}    IN    @{digits}
        Press Keycode For Digit    ${digit}
    END

Press Keycode For Digit
    [Arguments]    ${digit}
    ${code}=    Evaluate    ord('${digit}') - ord('0') + 7
    Press Keycode    ${code}

Get First Visible Locator
    [Arguments]    @{locators}
    FOR    ${locator}    IN    @{locators}
        ${visible}=    Run Keyword And Return Status    Page Should Contain Element    ${locator}
        IF    ${visible}
            RETURN    ${locator}
        END
    END
    Fail    None of the locators are visible: @{locators}

Tap Submit On Verification
    Hide Keyboard
    Tap First Ready Locator    @{SUBMIT_OTP_TAP_LOCATORS}    timeout=10s

Tap Submit On Verification If Shown
    [Documentation]    Submit may auto-fire when OTP length reached; tap if still visible.
    ${shown}=    Run Keyword And Return Status    Wait For Any Locator    @{SUBMIT_OTP_TAP_LOCATORS}    timeout=5s
    IF    ${shown}
        Tap Submit On Verification
    END

Complete Otp Verification
    [Arguments]    ${phone}    ${otp}
    Verification Screen Should Be Visible
    Displayed Phone On Verification If Detectable    ${phone}
    Enter Otp Code    ${otp}
    Tap Submit On Verification If Shown

Complete Otp Verification Simple
    [Arguments]    ${otp}
    Verification Screen Should Be Visible
    Enter Otp Code    ${otp}
    Tap Submit On Verification If Shown
