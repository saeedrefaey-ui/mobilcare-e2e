# PROJECT_PROFILE — MobilCare / CV_Auto

> Customization layer for **MobilCare** Android E2E automation in this repo.
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
| `tests_dir` | `Tests/` | Executable suites (`.robot`); steps only; call Module keywords; no locators or multi-screen business logic |
| `modules_dir` | `Resources/Modules/` | Business flows (login + OTP, role selection, fleet/driver journeys); `Resource` Pages + Common; no locator definitions |
| `pages_dir` | `Resources/Pages/` | Page Object Model: one file per screen; locators + atomic screen keywords only |
| `common_dir` | `Resources/Common/` | `BasePage.robot`, `setup_teardown.robot`, `language_keywords.robot`, `data_manager.robot` |
| `variables_dirs` | `Resources/Variables/` | `global_variables.robot`, `android_caps.robot`, `environments/` |
| `data_files` | `Utilities/Data/*.csv` (e.g. `Utilities/Data/Credentials.csv`) | CSV test data; append-only; placeholders in git; no secrets |
| `config_dir` | `Resources/Variables/` and `Utilities/Configuration/` | Appium caps, env overrides, optional YAML metadata |

### `file_map` — concrete mandatory-file paths

| Role | Path |
|---|---|
| Setup/teardown resource | `Resources/Common/setup_teardown.robot` |
| Parallel two-device setup | `Resources/Common/parallel_device_setup.robot` |
| Base interaction helpers | `Resources/Common/BasePage.robot` |
| Language switching | `Resources/Common/language_keywords.robot` |
| Data access resource | `Resources/Common/data_manager.robot` |
| Python CSV helper | `Libraries/CSV.py` |
| Page file pattern | `Resources/Pages/<Feature>/<Screen>Page.robot` |
| Flow/module file pattern | `Resources/Modules/<Feature>Keywords.robot` |
| Test suite pattern | `Tests/<Feature>/<scenario>.robot` |
| Test data file | `Utilities/Data/Credentials.csv` |
| Capabilities variables | `Resources/Variables/android_caps.robot` |
| Parallel device variables | `Resources/Variables/parallel_devices_variables.robot` |
| Global app variables | `Resources/Variables/global_variables.robot` |

### `import_pattern` — canonical Resource imports (from Test suite)

```robot
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/AuthenticationKeywords.robot
Resource    ../../Resources/Variables/global_variables.robot
```

Module files typically add:

```robot
Resource    ../Pages/Authentication/LoginPage.robot
Resource    ../Common/setup_teardown.robot
Resource    ../Common/data_manager.robot
```

Page files typically add:

```robot
Resource    ../../Common/BasePage.robot
Resource    ../../Common/setup_teardown.robot
Resource    ../../Variables/global_variables.robot
```

---

## 3. Automation Stack

| Key | Value |
|---|---|
| `ui_library` | AppiumLibrary |
| `extra_libraries` | none (`Libraries/CSV.py` via `data_manager.robot` is allowed) |
| `session_keywords` | `Open Application` / `Close Application` |
| `remote_session` | `${APPIUM_SERVER_URL}` (default `http://127.0.0.1:4723`); capabilities in `&{ANDROID_CAPS}`; override package with `-v APP_PACKAGE:...` |
| `forbidden_keywords` | `SeleniumLibrary`, `Open Browser`, `Close Browser`, `Go To`, any non-AppiumLibrary UI driver |
| `locator_priority` | `id=` → `accessibility_id=` → `-android uiautomator` → short relative `xpath=`; **never** absolute XPath |
| `locator_home` | `Resources/Pages/<Feature>/` by default; optional `Resources/Variables/<feature>_variables.robot` when shared across pages |
| `resource_extension` | `.robot` |
| `results_command` | `robot -d Results Tests/` |

---

## 4. Naming & Tagging Conventions

| Key | Value |
|---|---|
| `locator_variable_style` | `${UPPER_SNAKE}` with element-type prefix: `INP_`, `BTN_`, `LBL_`, `CHK_`, `FAB_` |
| `keyword_naming` | Title Case, imperative |
| `test_naming` | Descriptive behavior sentence; unique across suites |
| `tag_taxonomy` | `smoke`, `regression`, `android`, `authentication`, `fleet_owner`, `driver`, `single_owner` |

---

## 5. Data & Environments

| Key | Value |
|---|---|
| `env_variable_names` | `${APPIUM_SERVER_URL}`, `${APP_PACKAGE}`, `&{ANDROID_CAPS}`, `${lang}`, `${PARALLEL_UDID_DRIVER}`, `${PARALLEL_UDID_OWNER}` |
| `env_override_mechanism` | `robot -v APP_PACKAGE:com.trianglz.mobil_care.stg ...`; optional `Resources/Variables/environments/<env>.robot` |
| `secrets_policy` | No secrets in repo; placeholders in `Utilities/Data/Credentials.csv`; local override via `Utilities/Data/Credentials.local.csv` (gitignored) |

---

## 6. Project Overrides

- Android product source lives at **`trianglz-mobil_care-7d3f8059833a/`**.
- Personas map to Gradle modules: **fleet owner** → `fleet_owner`, **driver** → `driver`, **single owner** → `single_owner`.
- Do not use `Sleep` for synchronization; use AppiumLibrary wait keywords from `BasePage.robot`.
- RTL: app supports Arabic; locators that rely on `@text` must account for locale or use `id=` / bilingual dictionaries in `global_variables.robot`.
