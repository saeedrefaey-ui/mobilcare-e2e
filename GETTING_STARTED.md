# MobilCare E2E — Quick Guide

A short overview of **what is in this repo today** and **how to run it**.

For full architecture details, see [README.md](README.md).

---

## What this project is

Android end-to-end tests for the **MobilCare** app (fleet owner, driver, single owner), built with:

- **Robot Framework** — test runner and keywords
- **AppiumLibrary** — controls the app on emulator/device
- **Page Object Model (POM)** — UI locators and screen actions live in `Resources/PO/`; tests only call business keywords



---

## What is in the repo (current state)

```
CV_Auto/
├── Test/                          ← Test suites (what you run)
├── Resources/
│   ├── Common.robot               ← Appium open/close, shared waits
│   ├── DataManager.robot          ← Reads CSV test data
│   ├── PO/                        ← One file per screen (locators + taps)
│   ├── Modules/                   ← Business flows (multi-screen steps)
│   └── Variables/                 ← Appium caps + dev/stg package ids
├── Data/Credentials.csv           ← Phones, OTP, names (placeholders)
├── scripts/                       ← Setup, Appium, Android env
├── run_tests.sh                   ← Run Robot suites
 (reference)
└── .cursor/rules/                 ← Robo Builder agent + project profile
```

### Test suites available now

| File | What it does | Needs real device? |
|------|----------------|-------------------|
| `Test/mobilcare.robot` | Smoke — reach login screen after splash | Yes |
| `Test/fleet_owner_registration.robot` | **Full Fleet Owner registration** (16 steps, Arabic path) | Yes |
| `Test/authentication.robot` | Sign-in flows for fleet owner, driver, single owner | Yes |

### Main registration flow (implemented)

`Test/fleet_owner_registration.robot` runs:

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
5. **Real test data** in `Data/Credentials.csv` (placeholders will not pass on a real device)

Optional: install the [Robot Framework Language Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp) extension in Cursor for `.robot` syntax highlighting.

---

## One-time setup

From the project root:

```bash
bash scripts/setup.sh
```

This creates `.venv/` (Robot + AppiumLibrary), installs npm Appium locally, and installs the UiAutomator2 driver.

For Cursor highlighting, the repo already includes `.vscode/settings.json` pointing at `.venv/bin/python`.

---

## How to run tests

### 1. Start an Android emulator or connect a device

```bash
source scripts/env.sh
adb devices
```

You should see one device listed.

### 2. Start Appium (terminal 1)

```bash
./scripts/start_appium.sh
```

### 3. Run tests (terminal 2)

```bash
source .venv/bin/activate

# Smoke only
./run_tests.sh Test/mobilcare.robot

# Fleet Owner registration (your main flow)
./run_tests.sh Test/fleet_owner_registration.robot

# All tests
./run_tests.sh Test/
```

Results (log, report, screenshots) go to **`results/`**.

### Override app package (e.g. staging)

```bash
./run_tests.sh Test/ -v APP_PACKAGE:com.trianglz.mobil_care.stg
```

Default caps are in `Resources/Variables/capabilities/android_caps.robot`.

---

## Test data

Edit **`Data/Credentials.csv`** with real values for your environment:

| Column | Used for |
|--------|----------|
| `persona` | `fleet_owner`, `driver`, or `single_owner` |
| `phone` | Egyptian phone on login screen |
| `otp_hint` | OTP code (app expects **5 digits**; sheet uses `12345`) |
| `display_name` | Name on registration screen |

Do not commit real credentials. For local-only secrets you can use `Data/Credentials.local.csv` (gitignored) and point `DataManager.robot` at it later if needed.

---

## How the code is organized (simple rules)

| Layer | Folder | Rule |
|-------|--------|------|
| Tests | `Test/` | Call module keywords only; no locators |
| Business flows | `Resources/Modules/` | Combine PO steps (login + OTP + terms + …) |
| Screens | `Resources/PO/` | Locators + single-screen actions only |
| Shared | `Resources/Common.robot` | Appium session, waits |

**Example:** a test file should look like:

```robot
Complete Fleet Owner Registration Flow
```

Not raw `Click Element` or `${BTN_CONFIRM}` in `Test/`.

---

## Robo Builder (optional)

To generate or extend tests from regression sheets:

- Agent: `.cursor/rules/robo-builder.mdc`
- Project rules: `.cursor/rules/customization/PROJECT_PROFILE.md`

Copy from `PROJECT_PROFILE.example.md` if `PROJECT_PROFILE.md` is missing.

---

## Troubleshooting

| Problem | What to check |
|---------|----------------|
| No syntax highlighting in `.robot` files | Install Robot Framework Language Server extension; reload Cursor |
| `ANDROID_HOME` error | Run `source scripts/env.sh` or install Android SDK |
| No device in `adb devices` | Start emulator or plug in phone with USB debugging |
| Appium connection refused | Run `./scripts/start_appium.sh` |
| Tests fail on login/OTP | Update `Data/Credentials.csv` with valid phone and OTP |
| Wrong app opens | Match `APP_PACKAGE` to installed APK flavor (dev/stg) |

---

## What is not done yet

- Driver / single-owner **registration** suites matching a full sheet (only generic sign-in in `authentication.robot`)
- Fleet owner **post-login** features (vehicles, drivers, trips, …)
- CI pipeline
- Locators may need tuning from live Appium page source (Compose UI)

Use **`README.md`** for structure conventions and **`GETTING_STARTED.md`** (this file) for day-to-day usage.
