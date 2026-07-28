# PROJECT_PROFILE — Example (MobilCare / CV_Auto)

> Filled-in customization layer for **MobilCare** Android E2E automation in this repo.
> Copy to `customization/PROJECT_PROFILE.md` (same directory) and adjust only if your team diverges.
> Android product source for locator research: `trianglz-mobil_care-7d3f8059833a/`.

---

## 1. Project Identity

| Key | Value |
|---|---|
| `project_name` | MobilCare E2E — Fleet Owner & Driver |
| `platforms` | android |
| `default_target` | android |
| `readme_path` | `README.md` |

---

## 2. Folder Duties (extracted from the project README)

| Key | Path | Duty (what may live here) |
|---|---|---|
| `tests_dir` | `Test/` | Executable suites (`.robot`); steps only; call Module or PO keywords + `DataManager`; no locators or multi-screen business logic |
| `modules_dir` | `Resources/Modules/` | Business flows (login + OTP, role selection, fleet/driver journeys); `Resource` PO + `Common.robot`; no locator definitions |
| `pages_dir` | `Resources/PO/` | Page Object Model: one file per screen; locators + atomic screen keywords only |
| `common_dir` | `Resources/` (root) | `Common.robot` — Appium session setup/teardown, shared waits/helpers; `DataManager.robot` + `CSV.py` for data access |
| `variables_dirs` | `Resources/Variables/` | Optional split: `locators/`, `capabilities/`, `environments/` as the suite grows |
| `data_files` | `Data/*.csv` (e.g. `Data/Credentials.csv`) | CSV test data; append-only; placeholders in git; no secrets |
| `config_dir` | `Resources/Variables/capabilities/` and `Resources/Variables/environments/` | Appium caps and env overrides (preferred over hardcoding in suites) |

### `file_map` — concrete mandatory-file paths

| Role | Path |
|---|---|
| Setup/teardown + session resource | `Resources/Common.robot` |
| Data access resource | `Resources/DataManager.robot` |
| Python CSV helper | `Resources/CSV.py` |
| Wait / assertion keywords | `Resources/Common.robot` (shared section; split only if repo already does) |
| Page file pattern | `Resources/PO/<Screen>.robot` (e.g. `Login.robot`, `Verification.robot`, `Name.robot`, `SplashError.robot`, `Home.robot`) |
| Flow/module file pattern | `Resources/Modules/<Feature>Keywords.robot` |
| Test suite pattern | `Test/<area_or_persona>.robot` or `Test/<persona>/<feature>.robot` |
| Test data file | `Data/Credentials.csv` |
| Capabilities variables (optional) | `Resources/Variables/capabilities/android_caps.robot` |

### `import_pattern` — canonical Resource imports (from Test suite)

```robot
Library    AppiumLibrary
Resource    ../Resources/Common.robot
Resource    ../Resources/PO/Login.robot
Resource    ../Resources/DataManager.robot
```

Module files typically add:

```robot
Resource    ../PO/Login.robot
Resource    ../PO/Verification.robot
Resource    ../Common.robot
```

---

## 3. Automation Stack

| Key | Value |
|---|---|
| `ui_library` | AppiumLibrary |
| `extra_libraries` | none (`Resources/CSV.py` via `DataManager.robot` is allowed) |
| `session_keywords` | `Open Application` / `Close Application` |
| `remote_session` | `${APPIUM_SERVER_URL}` (default `http://127.0.0.1:4723`); capabilities in `&{ANDROID_CAPS}` or `Resources/Variables/capabilities/`; override package with `-v APP_PACKAGE:...` |
| `forbidden_keywords` | `SeleniumLibrary`, `Open Browser`, `Close Browser`, `Go To`, any non-AppiumLibrary UI driver |
| `locator_priority` | `accessibility_id=` (Compose `contentDescription` when set) → `id=` / Android resource id → `-android uiautomator` (UiSelector) → short relative `xpath=` using visible text from `values/strings.xml` or `values-ar/strings.xml` (EN/AR); **never** absolute XPath |
| `locator_home` | `Resources/PO/` by default; optional `Resources/Variables/locators/<feature>.robot` when a feature already splits locators out of PO |
| `resource_extension` | `.robot` |
| `results_command` | `robot -d results Test/` |

### Appium capabilities (UiAutomator2)

Launcher activity (from `splash` module):

`com.trianglz.splash.modules.splash.presentation.SplashActivity`

`appPackage` per flavor (`trianglz-mobil_care-7d3f8059833a/config/<flavor>.properties` → `APPLICATION_ID`):

| Flavor | `appPackage` |
|---|---|
| dev | `com.trianglz.mobil_care.dev` |
| stg | `com.trianglz.mobil_care.stg` |
| demo | `com.trianglz.mobil_care.demo` |
| prod | `com.trianglz.mobil_care` |
| live | `com.mobil.care` |

Example capability dict:

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

Install the flavor APK on device/emulator before running, or set `appium:app` to the APK path.

### Locator research — Android source layout

| Gradle module | Typical E2E scope |
|---|---|
| `splash` | Cold start, splash errors |
| `authentication` | Login (`LoginScreenContent`), OTP (`VerificationScreen`), terms, onboarding, role selection |
| `fleet_owner` | Fleet owner home, bird's eye, fleet workflows |
| `driver` | Driver home, rewards |
| `single_owner` | Single-owner vehicles, verification |
| `car_owner` | Car-owner persona flows |
| `driver_tracking` / `owner_tracking` / `common_tracking` | Live trip, trip summary, maps overlay |
| `common` | Shared Compose UI (`BaseTextField`, `MobilButtonWithBottomSpacing`, dialogs) |

UI is **Jetpack Compose**; few `testTag`s — prefer accessibility labels where present (e.g. `Add FAB`, `qr_image`), otherwise button/label text such as `Confirm`, `Sign in`, `Phone number` from string resources.

---

## 4. Naming & Tagging Conventions

| Key | Value |
|---|---|
| `locator_variable_style` | `${UPPER_SNAKE}` with element-type prefix: `INP_`, `BTN_`, `LBL_`, `CHK_`, `FAB_` |
| `keyword_naming` | Title Case, imperative (e.g. `Enter Phone Number And Tap Confirm`, `Complete Otp Verification`) |
| `test_naming` | Descriptive behavior sentence; unique across suites (e.g. `Verify Fleet Owner Can Sign In With Valid Phone And Otp`) |
| `tag_taxonomy` | `smoke`, `regression`, `android`, `authentication`, `fleet_owner`, `driver`, `single_owner`, feature area name |
| `extra_stopwords` | none |

---

## 5. Test Flow Structure

| Key | Value |
|---|---|
| `flow_source` | QC-Pilot / Robo Builder regression sheet (XLSX or equivalent tabular export) |
| `flow_record_shape` | One row per step |
| `flow_grouping_key` | Carried `(ID, Title)`; alternatively `(Module, Flow Title)` |
| `carry_forward_rule` | Blank `ID` / `Title` on continuation rows inherit from the row above; aggregate steps per logical flow |

### Column / field mapping (with synonyms, case-insensitive)

| Canonical field | Source column(s) / synonyms |
|---|---|
| Flow ID | `ID` |
| Title | `Title` / `Flow Title` / `Test Case` |
| Preconditions | `Preconditions` / `Preconditons` |
| Step action | `Step Action` / `Actions` |
| Expected result | `Expected Result` / `Expected Results` |
| Module / feature (optional) | `Module` / `Feature` / `Persona` (`fleet_owner`, `driver`, `single_owner`) |

### Screen evidence

| Key | Value |
|---|---|
| `screen_evidence_markers` | `BEGIN SCREEN FILE` / `END SCREEN FILE` |
| `screen_evidence_format` | Mobile: Appium page source XML (UiAutomator2 hierarchy); optional JSON snapshots |

### Example flow record

```
ID      | Title                    | Preconditions      | Step Action                         | Expected Result
FO-1    | Fleet Owner Registration | App on splash/dev  | Skip onboarding, switch Arabic (عربي) | Sign in in Arabic
        |                          |                    | Enter phone, Confirm                | Verification screen; phone displayed
        |                          |                    | Enter OTP 12345, Submit if shown    | Privacy / terms screen
        |                          |                    | Open Privacy Policy & Terms links   | Documents open; return to terms
        |                          |                    | Check boxes, Accept                 | Role selection
        |                          |                    | Select Fleet Owner, Confirm, Yes    | Name screen
        |                          |                    | Enter name, Confirm                 | Mobilawy Points tutorial visible
```

### Authentication flow order (MobilCare)

`Splash → [SplashError] → [Onboarding] → Login → OTP → Terms → Role → Name → Home`

Module keyword `Sign In As Persona With Otp And Role` implements this; each post-OTP step uses **If Shown** so returning users skip completed steps.

---

## 6. Data & Environments

| Key | Value |
|---|---|
| `env_variable_names` | `${APPIUM_SERVER_URL}`, `${APP_PACKAGE}`, `&{ANDROID_CAPS}`; CSV columns via `DataManager.robot` (persona, phone, otp_hint, display_name) |
| `env_override_mechanism` | `robot -v APP_PACKAGE:com.trianglz.mobil_care.stg ...`; optional `Resources/Variables/environments/<env>.robot`; local/private CSV not committed |
| `secrets_policy` | No secrets in repo; placeholders in `Data/Credentials.csv` + `-v` / private files only |

---

## 7. Project Overrides

- Android product source lives at **`trianglz-mobil_care-7d3f8059833a/`** (repo root), not under a separate `ProjectCode/` wrapper — use it for Compose/screens and `res/values*` strings when building XPath or confirming copy.
- Personas map to Gradle modules: **fleet owner** → `fleet_owner`, **driver** → `driver`, **single owner** → `single_owner`, **car owner** → `car_owner`.
- Do not use `Sleep` for synchronization in new keywords; use AppiumLibrary wait keywords from `Common.robot`.
- RTL: app supports Arabic (`values-ar/`); locators that rely on `@text` must account for locale or use language-agnostic strategies (accessibility id, uiautomator).
