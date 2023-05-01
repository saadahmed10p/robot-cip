*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library    ../PageObjects/TestWorthy_locators.py

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
#    ${count}=   Get Matching Xpath Count    //*[contains(text(), "Robot milestone")]
#    Log  ${count}  # Prints the number of matching elements with text "Robot milestone"
    #${li_count_before}=    Get Element Count    xpath:(//ul)[8]/li
    #Log To Console       ${li_count_before} li elements found in the UL
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