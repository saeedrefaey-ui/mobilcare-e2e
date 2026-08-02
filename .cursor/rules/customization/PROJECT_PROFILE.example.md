# PROJECT_PROFILE — Example (MobilCare / CV_Auto)

> Reference customization layer for **MobilCare** Android E2E automation.
> Copy to `customization/PROJECT_PROFILE.md` and adjust only if your team diverges.

---

## 1. Project Identity

| Key | Value |
|---|---|
| `project_name` | MobilCare E2E — Fleet Owner & Driver |
| `platforms` | android |
| `default_target` | android |
| `readme_path` | `README.md` |

---

## 2. Folder Duties

| Key | Path | Duty |
|---|---|---|
| `tests_dir` | `Tests/` | Executable suites; steps only; call Module keywords |
| `modules_dir` | `Resources/Modules/` | Business flows; Resource Pages + Common |
| `pages_dir` | `Resources/Pages/` | POM: one file per screen; locators + atomic keywords |
| `common_dir` | `Resources/Common/` | BasePage, setup/teardown, language, data_manager |
| `variables_dirs` | `Resources/Variables/` | global_variables, android_caps, environments |
| `data_files` | `Utilities/Data/*.csv` | CSV test data; no secrets in git |
| `config_dir` | `Utilities/Configuration/` | Optional env metadata |

### `file_map`

| Role | Path |
|---|---|
| Setup/teardown | `Resources/Common/setup_teardown.robot` |
| Base interactions | `Resources/Common/BasePage.robot` |
| Data access | `Resources/Common/data_manager.robot` |
| Python CSV helper | `Libraries/CSV.py` |
| Page pattern | `Resources/Pages/<Feature>/<Screen>Page.robot` |
| Module pattern | `Resources/Modules/<Feature>Keywords.robot` |
| Test pattern | `Tests/<Feature>/<scenario>.robot` |
| Test data | `Utilities/Data/Credentials.csv` |
| Capabilities | `Resources/Variables/android_caps.robot` |

### `import_pattern` (from Test suite)

```robot
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/AuthenticationKeywords.robot
```

---

## 3. Automation Stack

| Key | Value |
|---|---|
| `ui_library` | AppiumLibrary |
| `session_keywords` | `Open Application` / `Close Application` |
| `locator_priority` | `id=` → `accessibility_id=` → `-android uiautomator` → relative `xpath=` |
| `locator_home` | `Resources/Pages/<Feature>/` |
| `results_command` | `robot -d Results Tests/` |

---

## 4. Naming & Tags

| Key | Value |
|---|---|
| `keyword_naming` | Title Case, imperative |
| `tag_taxonomy` | `smoke`, `regression`, `android`, `authentication`, `fleet_owner`, `driver`, `single_owner` |

---

## 5. Data & Environments

| Key | Value |
|---|---|
| `env_override_mechanism` | `robot -v APP_PACKAGE:com.trianglz.mobil_care.stg ...` |
| `secrets_policy` | Placeholders in `Utilities/Data/Credentials.csv`; local file gitignored |
