*** Variables ***
${APPIUM_SERVER_URL}    http://127.0.0.1:4723
${APP_PACKAGE}          com.trianglz.mobil_care.dev
${APP_ACTIVITY}         com.trianglz.splash.modules.splash.presentation.SplashActivity

&{ANDROID_CAPS}
...    platformName=Android
...    appium:automationName=UiAutomator2
...    appium:appPackage=${APP_PACKAGE}
...    appium:appActivity=${APP_ACTIVITY}
...    appium:appWaitDuration=60000
...    appium:appWaitForLaunch=${TRUE}
...    appium:autoGrantPermissions=${TRUE}
...    appium:noReset=${TRUE}
...    appium:newCommandTimeout=300
