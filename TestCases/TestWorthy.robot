*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library    ../PageObjects/TestWorthy_locators.py
Library    ../Utils/variables.py

Resource    ../Resources/TestWorthy_resource.resource

Test Setup  Login   ${user}    ${env}  #${valid_username}   ${valid_password}
#Test Teardown   Logout

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

Edit Milestone
    [Documentation]    Verify Editing a milestone
    [Tags]             Regression
    Navigate To Milestone Tab    ${project_finstreet}
    Adding A Milestone
    #Sleep    3 seconds
    Editing A Milestone

Delete Milestone
    [Documentation]    Verify Deleting a milestone
    [Tags]             Regression
    Navigate To Milestone Tab    ${project_finstreet}
    Adding A Milestone
    Sleep    2 seconds
    ${count}    Count Matching XPaths    //*[text()="Robot milestone"]
    Log To Console    ${count}
    Wait Until Page Contains Element    ${created_mile}
    Click Element    ${created_mile}
    Wait Until Page Contains Element    id:optionsEllipsis
    Click Element    id:optionsEllipsis
    Wait Until Page Contains Element    xpath://a[@class='dropdown-item' and @milestone-name='Robot milestone']//img[@src='/new-assets/images/trash.png']
    Click Element    xpath://a[@class='dropdown-item' and @milestone-name='Robot milestone']//img[@src='/new-assets/images/trash.png']
    Sleep    3 seconds
    Wait Until Page Contains    Confirmation
    Click Element    id:btnDeleteMilestone
    Sleep    3 seconds
    Page Should Contain     Milestone Deleted
    Go Back
    Wait Until Page Contains Element    xpath:(//ul)[8]/li
#    ${li_count_after}=    Get Element Count    xpath:(//ul)[8]/li
#    Log To Console       ${li_count_after} li elements found in the UL
    ${count_after}    Count Matching XPaths    //*[text()="Robot milestone"]
    Log To Console    ${count_after}
    Should Not Be Equal    ${count}   ${count_after}

Test Suite
    [Documentation]    Verify Adding/Editing/Deleting a Test Suite
    [Tags]             Api
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Wait Until Page Contains     Test Suites and Cases
    Create Test Suite
    Reload Page
    Open Testsuite

    Edit Testsuite
    Wait Until Page Contains    ${updated_test_suite}

    Delete Testsuite
    Wait Until Page Contains        Test Suites and Cases
    Click Element    ${Back To Dashboard}

Adding Section
    [Documentation]    Verify Adding a Section
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Select Test Suite    ${testing_suite}
    Add Section
    Wait Until Page Contains        ${section_name}
    Click Element    ${back_to_dashboard}

Editing Section
    [Documentation]    Verify Editing a Section
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Select Test Suite    ${testing_suite}
    Add Section
    Editing Section
    Wait Until Page Contains    ${updated_section_name}
    Click Element    ${back_to_dashboard}

Deleting Section
    [Documentation]    Verify Deleting a Section
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Select Test Suite    ${testing_suite}
    Add Section
    Sleep    2 seconds
    ${initial_count}=   Get Divs Count
    Log To Console    Before deletion:${initial_count}
    Deleting Section
    ${deleted_count}=   Get Divs Count
    Log To Console    After deletion:${deleted_count}
    Should Not Be Equal    ${initial_count}     ${deleted_count}
    Click Element        ${back_to_dashboard}

Add Test Case
    [Documentation]    Verify Adding a Testcase
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Select Test Suite    ${testing_suite}
    Add Test Case
    Wait Until Page Contains        ${test_case_title}

Save and next
    [Documentation]    Verify Save and next Testcase
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Select Test Suite    ${testing_suite}
    Save And Next
    Wait Until Page Contains    Add Test Case

#Test Case Preview
#        [Documentation]    Verify Preview a Testcase
#        [Tags]             Regression
#        Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
#        Select Test Suite    ${testing_suite}
#        Preview Test Case

Delete Test Case
    [Documentation]    Verify Preview a Testcase
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Select Test Suite    ${testing_suite}
    ${before_del} =     Get Test Count
    Log To Console    count of test cases before delete: ${before_del}
    Delete Test Case
    ${after_del} =     Get Test Count
    Log To Console    count of test cases after delete: ${after_del}
    #Should Not Be Equal    ${before_del}    ${after_del}

Test runs
    [Documentation]    Verify adding a Test run with specific Test cases
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_run_tab}
    Add Test Run
    ${count}=   Get Counts   ${selected_count_txt}
    Should Not Be Equal    ${count}     0

Milestone Report
    [Documentation]    Verify generating report for milestones
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${reports_tab}
    Page Should Contain    Summary Report
    Milestone Reporting
    Wait Until Page Contains    Milestone Summary Report

Importing Test Cases
    [Documentation]    Verify importin test cases
    [Tags]             Regression
    Navigate To Tab    ${project_finstreet}     ${test_suite_tab}
    Import Test Cases
    Page Should Contain    Invalid file format.