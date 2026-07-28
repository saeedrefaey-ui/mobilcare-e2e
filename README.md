# MobilCare E2E

Mobile automation testing framework built with **Robot Framework** and **Appium** for scalable **Android** test automation of the **MobilCare** app (fleet owner, driver, and single-owner journeys), using a keyword-driven approach.

---

# 📱 MobilCare E2E – Mobile Automation Framework

Automation framework built using **Robot Framework + AppiumLibrary**.

MobilCare Android product source lives under `trianglz-mobil_care-7d3f8059833a/` for Compose screens, EN/AR strings, and build flavors. Test generation is supported by **Robo Builder** (`.cursor/rules/robo-builder.mdc`).

---

# 📁 Project Structure

```
CV_Auto/
├── Test/                                    # Test cases (steps only — NO business logic)
│   ├── mobilcare.robot                      # Smoke — login screen reachability
│   ├── authentication.robot                 # Full sign-in flows per persona
│   └── fleet_owner_registration.robot       # ID 1 — Fleet Owner | Registration sheet
│   │
│   │   # Recommended layout as features grow:
│   ├── Authentication/                      # (future)
│   │   ├── mobilcare.robot
│   │   └── authentication.robot
│   ├── FleetOwner/                          # (future)
│   │   └── fleet_home.robot
│   ├── Driver/                              # (future)
│   │   └── driver_home.robot
│   └── SingleOwner/                         # (future)
│       └── single_owner_home.robot
│
├── Resources/
│   ├── PO/                                  # ✅ Page Object Model (UI actions ONLY)
│   │   ├── Login.robot
│   │   ├── Onboarding.robot
│   │   ├── Verification.robot
│   │   ├── Terms.robot
│   │   ├── RoleSelection.robot
│   │   ├── Name.robot
│   │   ├── SplashError.robot
│   │   ├── Agreement.robot
│   │   ├── Tutorial.robot
│   │   ├── Home.robot                       # Persona home dispatcher
│   │   ├── FleetOwnerHome.robot
│   │   ├── DriverHome.robot
│   │   └── SingleOwnerHome.robot
│   │
│   │   # Recommended layout as screens grow:
│   │   ├── Authentication/                  # (future)
│   │   │   ├── Login.robot
│   │   │   ├── Onboarding.robot
│   │   │   ├── Verification.robot
│   │   │   ├── RoleSelection.robot
│   │   │   └── Terms.robot
│   │   ├── Home/                            # (future)
│   │   │   ├── FleetOwnerHome.robot
│   │   │   ├── DriverHome.robot
│   │   │   └── SingleOwnerHome.robot
│   │   └── FleetOwner/                      # (future — fleet workflows)
│   │
│   ├── Modules/                             # Business flows
│   │   ├── AuthenticationKeywords.robot
│   │   └── FleetOwnerRegistrationKeywords.robot
│   │   # FleetOwnerKeywords.robot           # (future)
│   │   # DriverKeywords.robot               # (future)
│   │   # SingleOwnerKeywords.robot          # (future)
│   │
│   ├── Common.robot                         # Shared setup, teardown, waits
│   ├── DataManager.robot                    # CSV data access
│   ├── CSV.py                               # Python helper for DataManager
│   │
│   └── Variables/
│       ├── locators/                        # Optional centralized locators
│       │   # authentication.robot           # (future)
│       │   # fleet_owner.robot              # (future)
│       │   # common.robot                   # (future)
│       │
│       ├── capabilities/
│       │   └── android_caps.robot
│       │
│       └── environments/
│           ├── dev.robot
│           └── stg.robot
│
├── Data/                                    # Test data (CSV); no secrets in repo
│   └── Credentials.csv
│
├── results/                                 # Robot output (log, report, screenshots)
│
├── trianglz-mobil_care-7d3f8059833a/        # MobilCare Android app (reference source)
│   ├── app/                                 # Flavors: dev, stg, demo, prod, live
│   ├── authentication/
│   ├── splash/
│   ├── fleet_owner/
│   ├── driver/
│   ├── single_owner/
│   ├── car_owner/
│   ├── driver_tracking/
│   ├── owner_tracking/
│   ├── common_tracking/
│   ├── common/
│   └── config/
│
├── .cursor/rules/
│   ├── robo-builder.mdc
│   └── customization/
│       ├── PROJECT_PROFILE.template.md
│       ├── PROJECT_PROFILE.example.md
│       └── PROJECT_PROFILE.md
│
├── requirements.txt
├── README.md
└── .gitignore
```

---

# ✅ Responsibilities by Folder

## 🧪 Test/

- Contains all test cases.
- Organized by feature/module (flat today; subfolders recommended as suites grow).
- Test cases should:
  - Call **module keywords only** (not PO locators directly).
  - Avoid embedding business logic.
  - Read test data from `Data/` via `Resources/DataManager.robot`.

**Current suites**

| File | Purpose |
|------|---------|
| `mobilcare.robot` | Smoke — splash → login screen |
| `authentication.robot` | Full sign-in per persona (`fleet_owner`, `driver`, `single_owner`) |

---

## 📦 Resources/Common.robot

Contains reusable setup, teardown, and wait helpers:

- `Begin All Tests` / `End All Tests`
- `Open MobilCare Application` / `Close All Applications`
- `Wait Until Element Is Ready`, `Tap When Ready`, `Input Text When Ready`

Capabilities are loaded from `Resources/Variables/capabilities/android_caps.robot`.

---

## 📄 Resources/PO/ (Page Object Model)

Implements **Page Object Model (POM)**.

- One `.robot` file per mobile screen (or persona home).
- Contains **locators and atomic screen keywords only**.
- No multi-screen business logic.

MobilCare uses **Jetpack Compose** — few `testTag`s; prefer accessibility labels and string resources from `trianglz-mobil_care-7d3f8059833a/**/values/strings.xml` (EN/AR).

### Locator best practices

1. Prefer:
   - `accessibility_id=`
   - `id=`
   - `-android uiautomator`
2. Use short relative `xpath=` only when necessary (localized `@text`).
3. Avoid absolute XPath.

**Example**

```robot
${INP_PHONE}       xpath=//android.widget.EditText
${BTN_CONFIRM}     -android uiautomator:new UiSelector().text("Confirm")
${FAB_ADD}         accessibility_id=Add FAB
```

**Reference (app source):** `trianglz-mobil_care-7d3f8059833a/authentication/.../LoginScreenContent.kt`

---

## 🔧 Resources/Modules/ (Business Actions)

Contains reusable business flows per feature.

Each module:

- Imports the corresponding PO files
- Imports `Common.robot` and `DataManager.robot`
- Implements reusable test flows (login + OTP + role + terms + home)

**Example**

```robot
*** Settings ***
Resource    ../PO/Login.robot
Resource    ../PO/Verification.robot
Resource    ../PO/RoleSelection.robot
Resource    ../Common.robot
Resource    ../DataManager.robot

*** Keywords ***
Sign In As Persona With Otp And Role
    [Arguments]    ${persona}
    ${phone}=    Get Credential Field For Persona    ${persona}    phone
    ${otp}=    Get Credential Field For Persona    ${persona}    otp_hint
    Reach Login Screen
    Sign In With Phone Number    ${phone}
    Complete Otp Verification    ${otp}
    Complete Role Selection For Persona    ${persona}
    Accept Terms If Shown
    Home Screen Should Be Visible For Persona    ${persona}
```

---

## 🧩 Resources/Variables/

Centralized variable management:

| Path | Purpose |
|------|---------|
| `capabilities/android_caps.robot` | UiAutomator2 desired capabilities |
| `environments/dev.robot` | Dev `APP_PACKAGE` override |
| `environments/stg.robot` | Staging `APP_PACKAGE` override |
| `locators/` | Optional split locators by feature (as suite grows) |

Keeps environment and platform configs separated from test logic.

---

## 🗂 Data/

Stores all test data:

- **CSV** today (`Credentials.csv` — persona, phone, otp_hint)
- Placeholders in git; real phones/OTP locally or via `Data/Credentials.local.csv` (gitignored)

**Columns:** `persona`, `phone`, `otp_hint`, `notes`

---

## 📊 results/

Stores Robot Framework output:

- `log.html`
- `report.html`
- `output.xml`
- Screenshots (on failure, when configured)

Run tests with output directory:

```bash
robot -d results Test/
```

---

## 📲 trianglz-mobil_care-7d3f8059833a/

MobilCare Android source for locator and flow reference during test design.

| Module | E2E scope |
|--------|-----------|
| `splash` | Cold start, launcher |
| `authentication` | Login, OTP, terms, role selection |
| `fleet_owner` | Fleet owner journeys |
| `driver` | Driver journeys |
| `single_owner` | Single owner journeys |
| `common` | Shared Compose UI components |

**Build flavors:** `dev`, `stg`, `demo`, `prod`, `live` — see `config/<flavor>.properties` for `APPLICATION_ID`.

---

# 📌 Framework Design Principles

✅ Clean separation of concerns  
✅ Page Object Model (POM)  
✅ Modular keyword design  
✅ Reusable business flows  
✅ Environment-driven execution  
✅ Persona-driven tags (`fleet_owner`, `driver`, `single_owner`)  
✅ Data-driven tests from CSV  
✅ AppiumLibrary only (no SeleniumLibrary)  

**Layering:** `Test → Module → PO → AppiumLibrary`

---

# ⚙️ Appium Capabilities

Target **UiAutomator2** on Android.

| Flavor | `appPackage` |
|--------|----------------|
| dev | `com.trianglz.mobil_care.dev` |
| stg | `com.trianglz.mobil_care.stg` |
| demo | `com.trianglz.mobil_care.demo` |
| prod | `com.trianglz.mobil_care` |
| live | `com.mobil.care` |

**Launcher activity:** `com.trianglz.splash.modules.splash.presentation.SplashActivity`

**Example** (`Resources/Variables/capabilities/android_caps.robot`):

```robot
${APPIUM_SERVER_URL}    http://127.0.0.1:4723
${APP_PACKAGE}          com.trianglz.mobil_care.dev

&{ANDROID_CAPS}
...    platformName=Android
...    appium:automationName=UiAutomator2
...    appium:appPackage=${APP_PACKAGE}
...    appium:appActivity=com.trianglz.splash.modules.splash.presentation.SplashActivity
...    appium:autoGrantPermissions=${TRUE}
...    appium:noReset=${TRUE}
...    appium:newCommandTimeout=300
```

Install the APK for the chosen flavor before running suites (or set `appium:app` to the APK path).

---

# 🔐 Authentication Flow (from app source & regression sheet)

## Fleet Owner | Registration (ID 1)

| Step | Action | Expected |
|------|--------|----------|
| 1 | Open application | Splash animation, app opens |
| 2 | Skip Onboarding | Sign in screen |
| 3 | Switch to Arabic (عربي) | App reopens in Arabic; sign in in Arabic |
| 4–5 | Enter phone, Confirm | Verification screen; phone shown |
| 6–7 | Enter OTP `12345`, Submit (if shown) | Privacy / terms screen |
| 8 | Open Privacy Policy | Policy opens |
| 9 | Back, open Terms and Conditions | Terms opens |
| 10–11 | Check 2 boxes, Accept | Role selection screen |
| 12–13 | Select Fleet Owner, Confirm | Confirmation dialog |
| 14 | Yes / Ok | Name entry screen |
| 15–16 | Enter name, Confirm | Logged in; **Mobilawy Points** tutorial step 1 |

**Test:** `Test/fleet_owner_registration.robot`  
**Module:** `Complete Fleet Owner Registration Flow` in `FleetOwnerRegistrationKeywords.robot`

## General new-user order

```
Splash → [SplashError] → [Onboarding] → Login → OTP → Terms → Role → Name → [Tutorial] → Home
```

---

# 🚀 Getting Started

## 1️⃣ Install Dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Make sure you have:

- Python 3
- Appium Server running
- Android SDK, emulator or device
- MobilCare APK for the target flavor

## 2️⃣ Activate Robo Builder Profile (optional)

```bash
cp .cursor/rules/customization/PROJECT_PROFILE.example.md \
   .cursor/rules/customization/PROJECT_PROFILE.md
```

## 3️⃣ Start Appium Server

```bash
appium
```

## 4️⃣ Run Tests

Run all tests:

```bash
robot -d results Test/
```

Run smoke only:

```bash
robot -d results Test/mobilcare.robot
```

Run authentication regression (requires device + valid credentials):

```bash
robot -d results Test/authentication.robot
```

Override environment package:

```bash
robot -d results -v APP_PACKAGE:com.trianglz.mobil_care.stg Test/
```

---

# 🧪 Test Flows & Robo Builder

Regression flows arrive as **tabular sheets** (XLSX): one row per step, with `ID` / `Title` carried forward on blank rows.

When generating tests with Robo Builder, attach mobile page source XML between:

`BEGIN SCREEN FILE` … `END SCREEN FILE`

| Resource | Path |
|----------|------|
| Core agent | `.cursor/rules/robo-builder.mdc` |
| Project profile | `.cursor/rules/customization/PROJECT_PROFILE.md` |
| Reference profile | `.cursor/rules/customization/PROJECT_PROFILE.example.md` |

---

# 👨‍💻 Happy Mobile Testing with Robot Framework & Appium 🚀
