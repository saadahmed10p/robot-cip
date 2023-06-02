*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library    OperatingSystem

Resource    ../Resources/TestWorthy_resource.resource


*** Variables ***
${csv_file}    TestData/expected_errors.csv
${msg}=  Get Row Data   ${csv_file}



*** Test Cases ***
Failed login
    [Documentation]    Verify error message is displayed with invalid credentials
    [Tags]             Regression
    Login    ${user}    ${env}
    Wait Until Page Contains      ${msg}[1]

