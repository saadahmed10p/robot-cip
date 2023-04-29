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


${PROJECT_XPATH}  //div[@class='carousel-card']/div[@class='carousel-card__text ']/h6/a
${TEST_PLAN_XPATH}    //div[@class='test-plan']
${TEXT_TO_FIND}   Create a test plan to manage and track all your test runs.

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

Navigate to Test Plan
    [Arguments]    ${project_name}
    Wait Until Page Contains Element    ${project_name}
    Click Element  ${project_name}
    Click Element   ${testplan_tab}

Find Text In All Projects
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    xpath=//*[@id="carousel_projects"]/div[1]/div/div[1]/div/div[1]/h6/a
    ${project_count}=    Get Element Count        xpath=//*[@id="carousel_projects"]/div/div/div/div/div[1]/h6/a
    Log    Found ${project_count} projects.
    FOR    ${index}    IN RANGE    1    ${project_count+1}
        ${project_name}=    Get Text    xpath=//*[@id="carousel_projects"]/div[${index}]/div/div[1]/div/div[1]/h6/a
        Click Element    xpath=//*[@id="carousel_projects"]/div[${index}]/div/div[1]/div/div[1]/h6/a
        Wait Until Page Contains    ${TEXT_TO_FIND}
        ${text_found}=    Run Keyword And Return Status    Should Contain    ${TEXT_TO_FIND}    ${BODY_TEXT}
        Close Browser
        Log    Project '${project_name}': Text Found=${text_found}
        Should Be True    ${text_found}
        [Return]    ${project_name}
    END

#Verify Text on Test Plan Tab for All Projects
#    Wait Until Page Contains Element    xpath://h6[@class='font-weight-bold mr-1' ]
#    ${project_count_txt}    Get Text    xpath://h6[@class='font-weight-bold mr-1' ]
#    ${project_count}=  Convert To Integer    ${project_count_txt}
#    Log To Console    aa:${project_count}
#    Wait Until Element Is Visible    ${PROJECT_XPATH}
#    FOR    ${i}    IN RANGE    1    ${project_count}+1
#        ${project_links} =    Get WebElements    ${PROJECT_XPATH}
#        ${project_link} =    Set Variable    ${project_links[${i}-1]}
#        ${project_name} =    Get Text    ${project_link}
#        Click Element    ${project_link}
#        Sleep    2s
#        Click Element    xpath=//a[contains(text(),'Test Plan')]
#        Wait Until Page Contains Element    xpath=//*[contains(text(),'Create a test plan to manage and track all your test runs.')]
#        ${body_text}=    Get Text    xpath=//body
#        Should Contain    ${body_text}    Create a test plan to manage and track all your test runs.
#        Log To Console       Text verified on Test Plan tab for project: ${project_name}
#        #Go Back
#        #Go Back
#        Click Element    xpath://a[@href='/Dashboard/Index' and @class='arrow-back']
#        Sleep    5 seconds
#    END

Verify Test Plan Button for All Projects
    Wait Until Page Contains Element    ${total_projects}
    ${project_count_txt}    Get Text    ${total_projects}
    ${project_count}=  Convert To Integer    ${project_count_txt}
    Log To Console    Total Projects are: ${project_count}
    Wait Until Element Is Visible    ${PROJECT_XPATH}
    FOR    ${i}    IN RANGE    1    ${project_count}+1
        ${project_links} =    Get WebElements    ${PROJECT_XPATH}
        ${project_link} =    Set Variable    ${project_links[${i}-1]}
        ${project_name} =    Get Text    ${project_link}
        Click Element    ${project_link}
        Click Element    ${testplan_tab}
        #Wait Until Page Contains Element    xpath=//*[contains(text(),'Create a test plan to manage and track all your test runs.')]
        ${body_text}=    Get Text    xpath=//body
        ${is_text_present}=    Run Keyword And Return Status    Should Contain    ${body_text}    Create a test plan to manage and track all your test runs.
        Log To Console    Project: ${project_name} - Text present on Test Plan tab: ${is_text_present}
        #Go Back
        #Go Back
        Click Element    ${back_to_dashboard}
        Wait Until Element Is Visible    ${PROJECT_XPATH}
    END
