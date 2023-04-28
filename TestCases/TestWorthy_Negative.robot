*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library    OperatingSystem

Resource    ../Resources/TestWorthy_resource.resource


*** Variables ***
${csv_file}    TestData/expected_errors.csv
${msg}=  Get Row Data   ${csv_file}

#robot -v user:user2 TestCases/TestWorthy_Negative.robot
#robot --test "Failed login" -v user:user2 TestCases/TestWorthy_Negative.robot

*** Test Cases ***
Failed login
    [Documentation]    Verify error message is displayed with invalid credentials
    [Tags]             Regression
    #Login      ${invalid_username}   ${valid_password}
    Login    ${user}
    Wait Until Page Contains      ${msg}[1]   #${invalid_creds_msg}