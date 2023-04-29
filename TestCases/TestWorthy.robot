*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py

Resource    ../Resources/TestWorthy_resource.resource

Test Setup  Login   ${user}      #${valid_username}   ${valid_password}
Test Teardown   Logout

*** Variables ***
${csv_file}    TestData/expected_errors.csv
${msg}=  Get Row Data   ${csv_file}

#robot --test  "Successful login" TestCases/TestWorthy.robot
#robot --include=Regression TestCases/TestWorthy.robot
#robot -v user:user1 TestCases/TestWorthy.robot
#robot --test "Successful login" -v user:user1 -i Regression TestCases/TestWorthy.robot

*** Test Cases ***
Successful login
    [Documentation]    Verify successful login with valid credentials
    [Tags]             Regression
    Wait Until Page Contains        ${msg}[3]

Test Plan
    [Documentation]    Verify Add Test plan button on test plan widget when no test plan exist
    [Tags]             Regression
    Verify Test Plan Button For All Projects
    Page Should Contain    Recent Activity

Add Milestone
    [Documentation]    Verify adding a milestone
    [Tags]             Regression
    Navigate To Milestone Tab    ${project_finstreet}
    Adding A Milestone
    ${date_check}=  Get Date(dmy)
    Log To Console    ${date_check}
    Wait Until Page Contains        ${date_check}
