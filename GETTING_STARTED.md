# MobilCare E2E — Quick Guide

A short overview of **what is in this repo today** and **how to run it**.

For full architecture details, see [README.md](README.md).

---

## What this project is

Android end-to-end tests for the **MobilCare** app (fleet owner, driver, single owner), built with:

- **Robot Framework** — test runner and keywords
- **AppiumLibrary** — controls the app on emulator/device
- **4-layer architecture** — Tests → Modules → Pages → Common/Variables

---

## What is in the repo (current state)

```
CV_Auto/
├── Tests/                         ← Test suites (what you run)
│   ├── Authentication/
│   └── Registration/
├── Resources/
│   ├── Common/                    ← BasePage, setup/teardown, language, data
│   ├── Pages/                     ← One file per screen (locators + taps)
│   ├── Modules/                   ← Business flows (multi-screen steps)
│   └── Variables/                 ← Caps, global vars, env overrides
├── Libraries/CSV.py               ← Python CSV helper
├── Utilities/Data/Credentials.csv ← Phones, OTP, names (placeholders)
├── scripts/                       ← Setup, Appium, Android env
├── run_tests.sh                   ← Run Robot suites
└── .cursor/rules/                 ← Robo Builder agent + project profile
```

### Test suites available now

| File | What it does | Needs real device? |
|------|----------------|-------------------|
| `Tests/Authentication/mobilcare.robot` | Smoke — reach login screen after splash | Yes |
| `Tests/Registration/fleet_owner_registration.robot` | Full Fleet Owner registration (16 steps, Arabic path) | Yes |
| `Tests/Authentication/authentication.robot` | Sign-in flows for fleet owner, driver, single owner | Yes |

### Main registration flow (implemented)

`Tests/Registration/fleet_owner_registration.robot` runs:

1. Open app → skip onboarding
2. Switch to **Arabic** (عربي)
3. Login with phone → OTP (`12345`) → Submit
4. Open Privacy Policy & Terms, check boxes, Accept
5. Select **Fleet Owner** → confirm dialog
6. Enter name → Confirm
7. Assert **Mobilawy Points** tutorial appears

Logic lives in `Resources/Modules/FleetOwnerRegistrationKeywords.robot` → keyword **`Complete Fleet Owner Registration Flow`**.

---

## Before you run anything

You need:

1. **Python 3** and **Node.js**
2. **Android SDK** (Android Studio is easiest) — emulator or USB device
3. **MobilCare APK** installed on that device (dev flavor: `com.trianglz.mobil_care.dev`)
4. **Appium** server running on `http://127.0.0.1:4723`
5. **Real test data** in `Utilities/Data/Credentials.csv` (placeholders will not pass on a real device)

Optional: install the [Robot Framework Language Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp) extension in Cursor for `.robot` syntax highlighting.

---

## One-time setup

From the project root:

```bash
bash scripts/setup.sh
```

This creates `.venv/` (Robot + AppiumLibrary), installs npm Appium locally, and installs the UiAutomator2 driver.

---

## How to run tests

### 1. Start an Android emulator or connect a device

```bash
source scripts/env.sh
adb devices
```

### 2. Start Appium (terminal 1)

```bash
./scripts/start_appium.sh
```

### 3. Run tests (terminal 2)

```bash
source .venv/bin/activate

# Smoke only
./run_tests.sh Tests/Authentication/mobilcare.robot

# Fleet Owner registration (main flow)
./run_tests.sh Tests/Registration/fleet_owner_registration.robot

# All tests
./run_tests.sh Tests/
```

Results (log, report, screenshots) go to **`Results/`**.

### Override app package (e.g. staging)

```bash
./run_tests.sh Tests/ -v APP_PACKAGE:com.trianglz.mobil_care.stg
```

Default caps are in `Resources/Variables/android_caps.robot`.

---

## Test data

Edit **`Utilities/Data/Credentials.csv`** with real values for your environment:

| Column | Used for |
|--------|----------|
| `persona` | `fleet_owner`, `driver`, or `single_owner` |
| `phone` | Egyptian phone on login screen |
| `otp_hint` | OTP code (app expects **5 digits**; sheet uses `12345`) |
| `display_name` | Name on registration screen |

Do not commit real credentials. For local-only secrets use `Utilities/Data/Credentials.local.csv` (gitignored).

---

## How the code is organized (simple rules)

| Layer | Folder | Rule |
|-------|--------|------|
| Tests | `Tests/` | Call module keywords only; no locators |
| Business flows | `Resources/Modules/` | Combine page steps (login + OTP + terms + …) |
| Screens | `Resources/Pages/` | Locators + single-screen actions only |
| Shared | `Resources/Common/` | Appium session, waits, language, data |

**Example:** a test file should look like:

```robot
Complete Fleet Owner Registration Flow
```

Not raw `Click Element` or `${BTN_CONFIRM}` in `Tests/`.

---

## Robo Builder (optional)

To generate or extend tests from regression sheets:

- Agent: `.cursor/rules/robo-builder.mdc`
- Project rules: `.cursor/rules/customization/PROJECT_PROFILE.md`

---

## Troubleshooting

| Problem | What to check |
|---------|----------------|
| No syntax highlighting in `.robot` files | Install Robot Framework Language Server extension; reload Cursor |
| `ANDROID_HOME` error | Run `source scripts/env.sh` or install Android SDK |
| No device in `adb devices` | Start emulator or plug in phone with USB debugging |
| Appium connection refused | Run `./scripts/start_appium.sh` |
| Tests fail on login/OTP | Update `Utilities/Data/Credentials.csv` with valid phone and OTP |
| Wrong app opens | Match `APP_PACKAGE` to installed APK flavor (dev/stg) |

---

## What is not done yet

- Driver / single-owner **registration** suites matching a full sheet
- Fleet owner **post-login** features (vehicles, drivers, trips, …)
- CI pipeline

Use **`README.md`** for structure conventions and **`GETTING_STARTED.md`** (this file) for day-to-day usage.
