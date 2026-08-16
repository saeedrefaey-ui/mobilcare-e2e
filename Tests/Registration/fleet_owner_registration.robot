*** Settings ***
Documentation    Fleet Owner Registration — flow ID 1 from regression sheet.
...    Override persona: ``-v PERSONA:driver`` or ``-v PERSONA:single_owner``.
Suite Setup       Begin All Tests
Suite Teardown    End All Tests
Resource    ../../Resources/Common/setup_teardown.robot
Resource    ../../Resources/Modules/RegistrationKeywords.robot


*** Variables ***
${PERSONA}    fleet_owner
${LANGUAGE}    ar


*** Test Cases ***
Verify Fleet Owner Registration Flow In Arabic
    [Documentation]    ID 1 | Registration for ``${PERSONA}`` — Arabic, terms review, role from persona, Mobilawy tutorial.
    [Tags]    regression    android    authentication    fleet_owner    requires_device
    Complete Full Registration Flow For Persona    ${PERSONA}    language=${LANGUAGE}
