*** Settings ***
Documentation    App identity, language, and bilingual UI strings for MobilCare Android.


*** Variables ***
${APP_PACKAGE}     com.trianglz.mobil_care.dev
${APP_ACTIVITY}    com.trianglz.splash.modules.splash.presentation.SplashActivity
${lang}            en

&{SIGN_IN_TITLE}       en=Sign in              ar=تسجيل الدخول
&{BTN_CONFIRM_TEXT}    en=Confirm              ar=تأكيد
&{BTN_ARABIC_LANG}     en=عربي                 ar=عربي
&{ROLE_FLEET_OWNER}    en=Fleet Owner          ar=صاحب اسطول
&{ROLE_DRIVER}         en=Driver               ar=سائق فى اسطول
&{ROLE_SINGLE_OWNER}   en=Single Owner         ar=سائق حر
&{SELECT_ROLE_TITLE}   en=Select your account type    ar=اختار نوع حسابك
