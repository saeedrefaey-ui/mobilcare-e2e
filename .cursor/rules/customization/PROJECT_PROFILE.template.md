# PROJECT_PROFILE — Robo Builder Customization Layer (TEMPLATE)

> Copy this file to `customization/PROJECT_PROFILE.md` in the target repo and fill every field.
> This is the **only** file that changes between projects. The core agent (`robo-builder.md`) reads
> it in Phase −1 and substitutes every `[profile: key]` slot from the values below.
>
> **Two inputs feed this file:**
> 1. The **project README** — sections 2–4 are extracted from it.
> 2. The **test flow structure** — section 5 describes the format your flows/regression sheets arrive in.
>
> Fields you cannot fill yet: write `TODO` — the agent will treat them as GAPs and ask.

---

## 1. Project Identity

| Key | Value |
|---|---|
| `project_name` | TODO |
| `platforms` | TODO <!-- e.g. web / android / ios / web+android --> |
| `default_target` | TODO <!-- what `auto` should resolve to when evidence is ambiguous --> |
| `readme_path` | `README.md` <!-- path to the authoritative README in the repo --> |

---

## 2. Folder Duties (extracted from the project README)

> Paste or restate the README's folder rules. Every directory the agent may write to must appear here.

| Key | Path | Duty (what may live here) |
|---|---|---|
| `tests_dir` | TODO <!-- e.g. Tests/ --> | Test cases only; call flow keywords; no selectors, no business logic |
| `modules_dir` | TODO <!-- e.g. Resources/Modules/ --> | Business-flow keywords; imports Pages + Common; no locator definitions |
| `pages_dir` | TODO <!-- e.g. Resources/Pages/ --> | POM: one file per screen; locators + screen-level keywords only |
| `common_dir` | TODO <!-- e.g. Resources/Common/ --> | Setup/teardown, shared waits, shared assertions |
| `variables_dirs` | TODO <!-- e.g. Resources/Variables/<feature>/ or "n/a" --> | Feature locator/copy variables (if the project splits them out of Pages) |
| `data_files` | TODO <!-- e.g. Utilities/Data/test_data.robot --> | Test data variables; append-only; no secrets |
| `config_dir` | TODO <!-- e.g. Utilities/Configuration/ or "n/a" --> | Per-environment variable files |

### `file_map` — concrete mandatory-file paths

| Role | Path |
|---|---|
| Setup/teardown resource | TODO |
| Common keywords resource | TODO |
| Wait keywords resource | TODO |
| Assertion keywords resource | TODO |
| Page file pattern | TODO <!-- e.g. Resources/Pages/<Screen>Page.robot --> |
| Flow/module file pattern | TODO <!-- e.g. Resources/Modules/<Feature>Keywords.robot --> |
| Test suite pattern | TODO <!-- e.g. Tests/<ModuleOrArea>/<feature>.robot --> |
| Test data file | TODO |

### `import_pattern` — canonical Resource imports (verbatim from README)

```robot
TODO
```

---

## 3. Automation Stack

| Key | Value |
|---|---|
| `ui_library` | TODO <!-- exactly one: SeleniumLibrary / Browser / AppiumLibrary / … --> |
| `extra_libraries` | TODO <!-- third-party non-UI libs allowed, e.g. RequestsLibrary, or "none". RF standard libraries (String, Collections, DateTime, …) are always permitted and need not be listed --> |
| `session_keywords` | TODO <!-- e.g. "Open Browser / Close Browser / Go To" --> |
| `remote_session` | TODO <!-- remote WebDriver/Appium URL + capabilities variable names, or "n/a" --> |
| `forbidden_keywords` | TODO <!-- e.g. "AppiumLibrary, Open Application, Close Application" or "none" --> |
| `locator_priority` | TODO <!-- ordered, e.g. "id= → data-testid → stable attrs → short relative XPath; absolute XPath never" --> |
| `locator_home` | TODO <!-- "Pages" / "Variables files" / "mixed — match feature's existing split" --> |
| `resource_extension` | TODO <!-- ".resource" (modern style guide) or ".robot" (legacy); match the existing repo --> |
| `results_command` | TODO <!-- e.g. robot -d Results Tests/ --> |

---

## 4. Naming & Tagging Conventions (from README / repo)

| Key | Value |
|---|---|
| `locator_variable_style` | TODO <!-- e.g. ${UPPER_SNAKE} with element-type prefix: BTN_, TXT_, LBL_ --> |
| `keyword_naming` | TODO <!-- e.g. Title Case, imperative --> |
| `test_naming` | TODO <!-- e.g. "Verify <behavior> When <condition>" --> |
| `tag_taxonomy` | TODO <!-- e.g. smoke / regression / <feature> / <platform>; list existing tags --> |
| `extra_stopwords` | TODO <!-- project-specific words to ignore in flow matching, or "none" --> |

---

## 5. Test Flow Structure (the flow source this project uses)

> Describes the format flows/regression cases arrive in. The core agent's flow matching and
> step→keyword mapping are driven entirely by this section.

| Key | Value |
|---|---|
| `flow_source` | TODO <!-- e.g. "QC-Pilot XLSX regression sheet", "Gherkin features", "TestRail CSV export", "Jira Xray" --> |
| `flow_record_shape` | TODO <!-- e.g. "one row per step" / "one block per flow" --> |
| `flow_grouping_key` | TODO <!-- e.g. "(ID, Title) carried forward on blank continuation rows" --> |
| `carry_forward_rule` | TODO <!-- how blank grouping cells are handled, or "n/a" --> |

### Column / field mapping (with synonyms, case-insensitive)

| Canonical field | Source column(s) / synonyms |
|---|---|
| Flow ID | TODO |
| Title | TODO <!-- e.g. Title / Flow Title / Test Case --> |
| Preconditions | TODO |
| Step action | TODO <!-- e.g. Step Action / Actions --> |
| Expected result | TODO <!-- e.g. Expected Result / Expected Results --> |
| Module / feature (optional) | TODO |

### Screen evidence

| Key | Value |
|---|---|
| `screen_evidence_markers` | TODO <!-- e.g. BEGIN SCREEN FILE / END SCREEN FILE --> |
| `screen_evidence_format` | TODO <!-- web: HTML/DOM; mobile: XML page source / JSON --> |

### Example flow record (paste a real, anonymized sample)

```
TODO
```

---

## 6. Data & Environments

| Key | Value |
|---|---|
| `env_variable_names` | TODO <!-- e.g. ${BASE_URL}, ${BROWSER}, ${REMOTE_URL}, ${CAPS_...} --> |
| `env_override_mechanism` | TODO <!-- e.g. -v on CLI, Utilities/Configuration/<env>.robot --> |
| `secrets_policy` | No secrets in repo; placeholders + `-v` overrides only <!-- adjust if project differs --> |

---

## 7. Project Overrides (optional)

> Anything where this project deviates from the core agent's universal rules.
> Leave empty if none. Overrides here win over core defaults but never over Hard Stops.

- TODO / none
