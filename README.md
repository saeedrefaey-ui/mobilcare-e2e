# MobilCare E2E

Mobile automation testing framework built with **Robot Framework** and **Appium** for scalable **Android** test automation of the **MobilCare** app (fleet owner, driver, and single-owner journeys), using a keyword-driven approach with a strict 4-layer architecture.

---

# Tech stack

| Layer | Technology |
|-------|------------|
| Test runner | Robot Framework |
| Mobile driver | Appium + AppiumLibrary |
| Platform | Android (UiAutomator2) |
| Custom logic | Python libraries in `Libraries/` |
| Languages | English + Arabic via `${lang}` and bilingual dictionaries |
| Test data | CSV in `Utilities/Data/` |

MobilCare Android product source lives under `trianglz-mobil_care-7d3f8059833a/` for Compose screens, EN/AR strings, and build flavors. Test generation is supported by **Robo Builder** (`.cursor/rules/robo-builder.mdc`).

---

# Architecture (4 layers)

```
Tests/          →  Steps only (no logic)
    ↓ calls
Modules/        →  Business flows (login, registration, …)
    ↓ calls
Pages/          →  One screen = one file; UI actions + screen locators
    ↓ uses
Common/ + Variables/ + Libraries/ + Utilities/  →  Shared helpers, caps, test data
```

| Layer | Responsibility |
|-------|----------------|
| **Tests/** | Executable suites; call module keywords only; no locators or business logic |
| **Resources/Modules/** | Multi-screen business flows; compose page keywords |
| **Resources/Pages/** | Page Object Model — locators + atomic screen actions only |
| **Resources/Common/** | Session lifecycle, BasePage interactions, language switching |
| **Resources/Variables/** | App identity, capabilities, bilingual strings, env overrides |
| **Utilities/Data/** | External CSV test data |
| **Libraries/** | Python Robot libraries |

---

# Project structure

```
CV_Auto/
├── Tests/                                    # Test suites — feature folders
│   ├── Authentication/
│   │   ├── mobilcare.robot                   # Smoke — login screen reachability
│   │   └── authentication.robot              # Full sign-in flows per persona
│   └── Registration/
│       └── fleet_owner_registration.robot    # ID 1 — Fleet Owner registration
│
├── Resources/
│   ├── Pages/                                # POM — UI only
│   │   ├── Authentication/
│   │   │   ├── LoginPage.robot
│   │   │   ├── OnboardingPage.robot
│   │   │   ├── VerificationPage.robot
│   │   │   ├── TermsPage.robot
│   │   │   ├── RoleSelectionPage.robot
│   │   │   ├── NamePage.robot
│   │   │   ├── SplashErrorPage.robot
│   │   │   ├── TutorialPage.robot
│   │   │   ├── PermissionsPage.robot
│   │   │   └── AgreementPage.robot
│   │   └── Home/
│   │       ├── HomePage.robot
│   │       ├── FleetOwnerHomePage.robot
│   │       ├── DriverHomePage.robot
│   │       └── SingleOwnerHomePage.robot
│   │
│   ├── Modules/                              # Business keywords
│   │   ├── AuthenticationKeywords.robot
│   │   └── FleetOwnerRegistrationKeywords.robot
│   │
│   ├── Common/                               # Cross-cutting infrastructure
│   │   ├── BasePage.robot                    # Shared wait/click/input helpers
│   │   ├── setup_teardown.robot              # App open/close, foreground checks
│   │   ├── parallel_device_setup.robot       # Two-device sessions (driver + owner)
│   │   ├── common_keywords.robot             # Shared non-UI flows
│   │   ├── language_keywords.robot           # EN/AR switching
│   │   └── data_manager.robot                # CSV test data access
│   │
│   ├── Variables/
│   │   ├── global_variables.robot            # App package, bilingual UI strings
│   │   ├── android_caps.robot                # Appium UiAutomator2 caps
│   │   ├── parallel_devices_variables.robot  # Two-device UDIDs, aliases, system ports
│   │   └── environments/
│   │       ├── dev.robot
│   │       └── stg.robot
│
├── Libraries/
│   └── CSV.py                                  # Python CSV helper for data_manager
│
├── Utilities/
│   ├── Data/
│   │   └── Credentials.csv                   # Persona phones, OTP, display names
│   └── Configuration/
│       └── qa.yaml                           # Environment metadata placeholder
│
├── Results/                                  # Robot output (gitignored)
│
├── trianglz-mobil_care-7d3f8059833a/         # MobilCare Android app (reference source)
│
├── scripts/                                  # Setup, Appium, Android env helpers
├── run_tests.sh
├── requirements.txt
├── README.md
└── .cursor/rules/                            # Robo Builder agent + project profile
```

---

# Layer responsibilities

## Tests/ — steps only

Rules:

- Import **Modules** and **Common** — not Pages directly.
- Call module keywords; avoid locators and business logic.
- Use `Suite Setup` / `Suite Teardown` for app lifecycle.

Example (`Tests/Authentication/authentication.robot`):

```robot
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/AuthenticationKeywords.robot

Verify Fleet Owner Can Sign In With Valid Phone And Otp
    Sign In As Persona With Otp And Role    fleet_owner
```

## Resources/Modules/ — business flows

One module per feature area. Each module imports relevant Pages, Common, and data_manager; composes page keywords into flows.

Example chain in `AuthenticationKeywords.robot`:

```
Sign In As Persona With Otp And Role
  → Reach Login Screen              (SplashErrorPage, OnboardingPage, LoginPage)
  → Sign In With Phone Number       (LoginPage)
  → Complete Otp Verification       (VerificationPage)
  → Complete Registration After Otp (TermsPage, RoleSelectionPage, NamePage)
  → Home Screen Should Be Visible   (HomePage)
```

## Resources/Pages/ — POM (UI only)

One `.robot` file per screen:

- Screen-specific locators in `*** Variables ***`
- Keywords = atomic UI actions only
- Always imports `BasePage.robot` + `setup_teardown.robot` when foreground checks are needed
- No multi-step business logic

Example from `LoginPage.robot`:

```robot
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot

Enter Phone Number And Tap Confirm
    Enter Phone Number    ${phone}
    Tap Confirm On Login
```

## Resources/Common/ — infrastructure

| File | Role |
|------|------|
| `BasePage.robot` | Reusable wait/click/input/swipe helpers |
| `setup_teardown.robot` | `Begin All Tests` / `End All Tests`, open/close app |
| `parallel_device_setup.robot` | `Begin Parallel Two Device Apps`, session switching |
| `language_keywords.robot` | Switch to Arabic, confirm language dialog |
| `common_keywords.robot` | Shared flows as the suite grows |
| `data_manager.robot` | Load persona credentials from CSV |

## Resources/Variables/ — locators & config

| File | Contents |
|------|----------|
| `global_variables.robot` | App identity, `${lang}`, bilingual UI dictionaries |
| `android_caps.robot` | `${APPIUM_SERVER_URL}`, `&{ANDROID_CAPS}` |
| `parallel_devices_variables.robot` | `${PARALLEL_UDID_DRIVER}`, `${PARALLEL_UDID_OWNER}`, system ports |
| `environments/dev.robot` | Dev `APP_PACKAGE` override |
| `environments/stg.robot` | Staging `APP_PACKAGE` override |

Bilingual pattern:

```robot
&{SIGN_IN_TITLE}    en=Sign in    ar=تسجيل الدخول
```

---

# Locator strategy

1. Prefer `id=` when available (e.g. `id=android:id/button1`)
2. Use `accessibility_id=` for Compose content descriptions
3. Use `-android uiautomator` for text-based UiSelector
4. Use short relative `xpath=` when ID is missing (most Compose UI)
5. Text-based locators for bilingual apps: `//android.widget.TextView[@text="…"]`

Locators live in Page `*** Variables ***` sections, not in Tests.

---

# App & device configuration

## Capabilities (`Resources/Variables/android_caps.robot`)

| Variable | Default |
|----------|---------|
| `${APPIUM_SERVER_URL}` | `http://127.0.0.1:4723` |
| `${APP_PACKAGE}` | `com.trianglz.mobil_care.dev` |
| `${APP_ACTIVITY}` | `com.trianglz.splash.modules.splash.presentation.SplashActivity` |

| Flavor | `appPackage` |
|--------|----------------|
| dev | `com.trianglz.mobil_care.dev` |
| stg | `com.trianglz.mobil_care.stg` |
| demo | `com.trianglz.mobil_care.demo` |
| prod | `com.trianglz.mobil_care` |
| live | `com.mobil.care` |

Install the APK for the chosen flavor before running suites.

## Parallel two-device runs (future flows)

Use when a suite needs **two phones/emulators** at once (e.g. fleet owner shares a vehicle to a driver).

**Resources:** `Resources/Common/parallel_device_setup.robot` + `Resources/Variables/parallel_devices_variables.robot`

**Suite pattern:**

```robot
Suite Setup       Begin Parallel Two Device Apps
Suite Teardown    End Parallel Two Device Apps
Resource    ../../Resources/Common/parallel_device_setup.robot

Some Two Device Flow
    Switch To Parallel Owner Session
    # ... fleet owner actions ...
    Switch To Parallel Driver Session
    # ... driver actions ...
```

**Run example:**

```bash
robot -d Results \
  -v APP_PACKAGE:com.trianglz.mobil_care.stg \
  -v PARALLEL_UDID_DRIVER:emulator-5554 \
  -v PARALLEL_UDID_OWNER:emulator-5556 \
  Tests/Parallel/your_parallel_suite.robot
```

| Variable | Purpose |
|----------|---------|
| `PARALLEL_UDID_DRIVER` | adb serial for driver device (alias `driver`) |
| `PARALLEL_UDID_OWNER` | adb serial for fleet owner device (alias `owner`) |
| `PARALLEL_DRIVER_SYSTEM_PORT` | UiAutomator2 port for driver (default `8200`) |
| `PARALLEL_OWNER_SYSTEM_PORT` | UiAutomator2 port for owner (default `8201`) |

Switch sessions in modules with `Switch To Parallel Driver Session` / `Switch To Parallel Owner Session`.

---

# Authentication flows

## Fleet Owner | Registration (ID 1)

| Step | Action | Expected |
|------|--------|----------|
| 1 | Open application | Splash animation, app opens |
| 2 | Skip Onboarding | Sign in screen |
| 3 | Switch to Arabic (عربي) | App reopens in Arabic |
| 4–5 | Enter phone, Confirm | Verification screen |
| 6–7 | Enter OTP `12345`, Submit | Privacy / terms screen |
| 8–9 | Open Privacy Policy & Terms | Documents open; return |
| 10–11 | Check 2 boxes, Accept | Role selection screen |
| 12–14 | Select Fleet Owner, Confirm, Ok | Name entry screen |
| 15–16 | Enter name, Confirm | Mobilawy Points tutorial |

**Test:** `Tests/Registration/fleet_owner_registration.robot`  
**Module:** `Complete Fleet Owner Registration Flow`

## General new-user order

```
Splash → [SplashError] → [Onboarding] → Login → OTP → Terms → Role → Name → [Tutorial] → Home
```

---

# Getting started

## 1. Install dependencies

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Or use the setup script:

```bash
bash scripts/setup.sh
```

Prerequisites:

- Python 3
- Appium Server running
- Android SDK, emulator or device
- MobilCare APK for the target flavor

## 2. Start Appium

```bash
./scripts/start_appium.sh
```

## 3. Run tests

```bash
# All tests
robot -d Results Tests/

# Smoke only
robot -d Results Tests/Authentication/mobilcare.robot

# Authentication regression
robot -d Results Tests/Authentication/authentication.robot

# Fleet Owner registration (Arabic path)
robot -d Results Tests/Registration/fleet_owner_registration.robot

# Override environment package
robot -d Results -v APP_PACKAGE:com.trianglz.mobil_care.stg Tests/

# Arabic locale (when keywords support ${lang})
robot -d Results -v lang:ar Tests/Registration/fleet_owner_registration.robot
```

Or use the helper script:

```bash
./run_tests.sh Tests/
./run_tests.sh Tests/Authentication/mobilcare.robot
```

---

# Test data

Edit **`Utilities/Data/Credentials.csv`** with real values for your environment:

| Column | Used for |
|--------|----------|
| `persona` | `fleet_owner`, `driver`, or `single_owner` |
| `phone` | Phone number on login screen |
| `otp_hint` | OTP code (5 digits; sheet uses `12345`) |
| `display_name` | Name on registration screen |

Do not commit real credentials. Use `Utilities/Data/Credentials.local.csv` (gitignored) for local-only secrets.

---

# Import path rules

From `Tests/<Feature>/test.robot`:

```robot
Resource    ../../Resources/Modules/AuthenticationKeywords.robot
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Variables/global_variables.robot
```

From `Resources/Modules/AuthenticationKeywords.robot`:

```robot
Resource    ../Pages/Authentication/LoginPage.robot
Resource    ../Common/setup_teardown.robot
Resource    ../Common/data_manager.robot
```

From `Resources/Pages/Authentication/LoginPage.robot`:

```robot
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
```

---

# Naming conventions

| Item | Convention | Example |
|------|------------|---------|
| Test files | snake_case | `fleet_owner_registration.robot` |
| Page files | `<Screen>Page.robot` | `LoginPage.robot` |
| Module files | `<Feature>Keywords.robot` | `AuthenticationKeywords.robot` |
| Keywords | Title Case phrases | `Sign In As Persona With Otp And Role` |
| Robot vars | `${UPPER_SNAKE}` | `${INP_PHONE}` |
| Bilingual dicts | `&{NAME}` with en/ar keys | `&{SIGN_IN_TITLE}` |

---

# Framework design principles

- Clean separation of concerns (Tests → Modules → Pages → Common)
- Page Object Model with feature-grouped pages
- Modular keyword design
- Reusable business flows
- Environment-driven execution (`-v APP_PACKAGE:…`)
- Persona-driven tags (`fleet_owner`, `driver`, `single_owner`)
- Data-driven tests from CSV
- AppiumLibrary only (no SeleniumLibrary)
- ID first, XPath second

---

# Robo Builder

Regression flows arrive as tabular sheets (XLSX). When generating tests, attach mobile page source XML between `BEGIN SCREEN FILE` … `END SCREEN FILE`.

| Resource | Path |
|----------|------|
| Core agent | `.cursor/rules/robo-builder.mdc` |
| Project profile | `.cursor/rules/customization/PROJECT_PROFILE.md` |

See also [GETTING_STARTED.md](GETTING_STARTED.md) for day-to-day usage.

---

# Happy Mobile Testing with Robot Framework & Appium
