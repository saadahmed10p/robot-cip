*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library     JSONLibrary
Library    OperatingSystem
Library    Collections

Variables    ../PageObjects/TestWorthy_locators.py
Variables    ../TestData/TestWorthy_TestData.py

*** Variables ***
#${config_file}    TestData/TestWorthy_Users.json
${csv_file}    TestData/expected_errors.csv
${msg}=  Get Row Data   ${csv_file}

*** Keywords ***
Open My Browser
    Open Browser    ${URL}  ${browser}
    Maximize Browser Window

Close My Browser
    Close Browser

#Login
#    [Arguments]    ${username}   ${password}
#    Open My Browser
#    Input Text    ${email_txt}   ${username}
#    Input Text    ${password_txt}   ${password}
#    Click Element   ${login_btn}


Get User Credentials
    [Arguments]    ${user}
    ${user_config_file}=    Set Variable    ${CURDIR}/../TestData/TestWorthy_Users.json
    ${user_data}=    Evaluate    json.load(open('${user_config_file}'))    json
    ${user_key}=    Set Variable    ${user}
    ${username}=    Set Variable    ${user_data['users']['${user_key}']['username']}
    ${password}=    Set Variable    ${user_data['users']['${user_key}']['password']}
    [Return]    ${username}    ${password}

Login
    [Arguments]    ${user}
    ${username_txt}=    Set Variable    ${email_txt}
    ${password_txt}=    Set Variable    ${password_txt}
    ${login_btn}=    Set Variable    ${login_btn}
    ${username}    ${password}=  Get User Credentials  ${user}
    Open My Browser
    Input Text    ${username_txt}    ${username}
    Input Text    ${password_txt}    ${password}
    Click Button    ${login_btn}



Logout
    Wait Until Element Is Visible   ${header_dropdown}
    Click Element    ${header_dropdown}
    Click Element    ${logout_element}
    Wait Until Element Is Visible   ${logout_btn}
    Click Button     ${logout_btn}
    Wait Until Page Contains        ${msg}[2]
    Close My Browser