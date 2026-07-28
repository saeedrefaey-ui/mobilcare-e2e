*** Settings ***
Documentation    Load test data from CSV under Data/.
Library    CSV.py

*** Variables ***
${DATA_DIR}              ${CURDIR}/../Data
${CREDENTIALS_FILE}      ${DATA_DIR}/Credentials.csv

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
