*** Settings ***
Documentation    Fleet Owner Registration — flow ID 1 from regression sheet (Arabic path).
Resource    RegistrationKeywords.robot


*** Keywords ***
Complete Fleet Owner Registration Flow
    [Documentation]    ID 1 — Fleet Owner | Registration (16 steps). Alias for persona ``fleet_owner``.
    Complete Registration Flow For Persona In Arabic    fleet_owner
