*** Settings ***
Library           OperatingSystem
*** Variables ***
${condition}      True
*** Test Cases ***
Test Case 1
    [Documentation]    This is Test Case 1
    Log To Console    Executing Test Case 1
Test Case 2
    [Documentation]    This is Test Case 2
    ${a}=   Test Case 1
    Run Keyword If    ${condition}     Test Case 1
    Log To Console    Executing Test Case 2