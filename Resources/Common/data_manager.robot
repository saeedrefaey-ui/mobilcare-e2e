*** Settings ***
Documentation    Load test data from CSV under Utilities/Data/.
Library    Collections
Library    DateTime
Library    ../../Libraries/CSV.py
Resource    ../Variables/global_variables.robot

*** Variables ***
${DATA_DIR}              ${CURDIR}/../../Utilities/Data
${CREDENTIALS_FILE}      ${DATA_DIR}/Credentials.csv
${VEHICLES_FILE}         ${DATA_DIR}/Vehicles.csv
@{SUPPORTED_PERSONAS}    fleet_owner    driver    single_owner

*** Keywords ***
Load Credentials For Persona
    [Documentation]    Returns a dictionary row for ``persona`` (fleet_owner, driver, single_owner, …).
    [Arguments]    ${persona}
    ${row}=    Get Row By Column    ${CREDENTIALS_FILE}    persona    ${persona}
    RETURN    ${row}

Get Credential Field For Persona
    [Documentation]    Single column value from Credentials.csv for a persona.
    [Arguments]    ${persona}    ${field}
    ${row}=    Load Credentials For Persona    ${persona}
    ${value}=    Set Variable    ${row}[${field}]
    RETURN    ${value}

Validate Persona Exists
    [Documentation]    Fails if ``persona`` is unknown or missing from Credentials.csv.
    [Arguments]    ${persona}
    ${supported}=    Run Keyword And Return Status    List Should Contain Value    ${SUPPORTED_PERSONAS}    ${persona}
    IF    not ${supported}
        Fail    Unknown persona '${persona}'. Supported: @{SUPPORTED_PERSONAS}
    END
    Load Credentials For Persona    ${persona}

Get Persona Role Dictionary
    [Documentation]    EN/AR role card labels for ``persona`` (from global_variables.robot).
    [Arguments]    ${persona}
    Validate Persona Exists    ${persona}
    IF    '${persona}' == 'fleet_owner'
        RETURN    ${ROLE_FLEET_OWNER}
    ELSE IF    '${persona}' == 'driver'
        RETURN    ${ROLE_DRIVER}
    ELSE IF    '${persona}' == 'single_owner'
        RETURN    ${ROLE_SINGLE_OWNER}
    END
    Fail    No role mapping for persona: ${persona}

Get Role Label For Persona
    [Documentation]    Role card label on screen for ``persona`` in ``language`` (en or ar).
    [Arguments]    ${persona}    ${language}=en
    ${roles}=    Get Persona Role Dictionary    ${persona}
    ${label}=    Set Variable    ${roles}[${language}]
    RETURN    ${label}

Load Persona Credentials
    [Documentation]    Returns phone, otp, and display_name for ``persona`` as a dictionary.
    [Arguments]    ${persona}
    Validate Persona Exists    ${persona}
    ${phone}=    Get Credential Field For Persona    ${persona}    phone
    ${otp}=    Get Credential Field For Persona    ${persona}    otp_hint
    ${display_name}=    Get Credential Field For Persona    ${persona}    display_name
    ${credentials}=    Create Dictionary
    ...    persona=${persona}
    ...    phone=${phone}
    ...    otp=${otp}
    ...    display_name=${display_name}
    RETURN    ${credentials}

Generate Unique License Plate
    [Documentation]    AUT + day/time so each run uses a new vehicle name (e.g. AUT06005612).
    ${stamp}=    Get Current Date    result_format=%d%H%M%S
    ${plate}=    Set Variable    AUT${stamp}
    RETURN    ${plate}

Load Vehicle Test Data
    [Documentation]    Vehicle row from Vehicles.csv; license_plate is replaced with a unique value each call.
    [Arguments]    ${vehicle_key}=default
    ${row}=    Get Row By Column    ${VEHICLES_FILE}    vehicle_key    ${vehicle_key}
    ${row}=    Copy Dictionary    ${row}
    ${plate}=    Generate Unique License Plate
    Set To Dictionary    ${row}    license_plate=${plate}
    Log    Using unique license plate: ${plate}
    RETURN    ${row}

Get Vehicle Field
    [Documentation]    Single column from Vehicles.csv for ``vehicle_key``.
    [Arguments]    ${vehicle_key}    ${field}
    ${row}=    Load Vehicle Test Data    ${vehicle_key}
    ${value}=    Set Variable    ${row}[${field}]
    RETURN    ${value}
