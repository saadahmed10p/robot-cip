*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library     JSONLibrary
Library    OperatingSystem
Library    Collections
Library  DateTime
Library    JSONLibrary
Library  RequestsLibrary
#Library  XML
Library  BeautifulSoup
Library  BuiltIn
Library  String
Library    ../Utils/variables.py

Variables    ../PageObjects/TestWorthy_locators.py
Variables    ../TestData/TestWorthy_TestData.py

*** Variables ***
#${config_file}    TestData/TestWorthy_Users.json
${csv_file}    TestData/expected_errors.csv
${msg}=  Get Row Data   ${csv_file}

${PROJECT_XPATH}  //div[@class='carousel-card']/div[@class='carousel-card__text ']/h6/a
${TEST_PLAN_XPATH}    //div[@class='test-plan']
${TEXT_TO_FIND}   Create a test plan to manage and track all your test runs.

${base_url}       https://testworthy.us
${login_url}      ${base_url}/Login
${create_url}     ${base_url}/TestSuite/Create
${project_id}     1211
${test_names}      abc


*** Keywords ***
Open My Browser
    [Arguments]    ${URL}
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

Get Env
    [Arguments]    ${env}
    ${user_config_file}=    Set Variable    ${CURDIR}/../TestData/TestWorthy_Users.json
    ${user_data}=    Evaluate    json.load(open('${user_config_file}'))    json
    ${user_key}=    Set Variable    ${env}
    ${environment}=    Set Variable    ${user_data['env']['${user_key}']['url']}
    [Return]    ${environment}

Get User Credentials
    [Arguments]    ${user}
    ${user_config_file}=    Set Variable    ${CURDIR}/../TestData/TestWorthy_Users.json
    ${user_data}=    Evaluate    json.load(open('${user_config_file}'))    json
    ${user_key}=    Set Variable    ${user}
    ${username}=    Set Variable    ${user_data['users']['${user_key}']['username']}
    ${password}=    Set Variable    ${user_data['users']['${user_key}']['password']}
    [Return]    ${username}    ${password}

Login
    [Arguments]    ${user}  ${env}
    ${username_txt}=    Set Variable    ${email_txt}
    ${password_txt}=    Set Variable    ${password_txt}
    ${login_btn}=    Set Variable    ${login_btn}
    ${username}    ${password}=  Get User Credentials  ${user}
    ${env}=     Get Env     ${env}
    Open My Browser     ${env}
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

Navigate to Milestone Tab
    [Arguments]    ${project_name}
    Wait Until Page Contains Element    ${project_name}
    Click Element    ${project_name}
    Click Element   ${milestone_tab}
    Page Should Contain    Add Milestone

Adding a Milestone
    Wait Until Page Contains Element    ${add_milestone_btn}
    Click Button    ${add_milestone_btn}
    Wait Until Element Is Visible            ${milestone_name_txt}
    Input Text    ${milestone_name_txt}     ${milestone_name}
    ${desc}=    Get Random String
    Input Text  ${milestone_desc_txt}   ${desc}
    ${start_date}=    get current date     result_format=%m/%d/%Y
    ${end_date}=    get current date     result_format=%m/%d/%Y     increment=+1 day
    Input Text    id:dpStartDate    ${start_date}
    Input Text    id:dpEndDate      ${end_date}
    Click Element    ${add_milestone_btnConfirm}
    Wait Until Page Contains    Milestones
    Wait Until Element Is Visible   ${header_dropdown}

Get Date(dmy)
    ${date}=    Get Current Date    result_format=%d/%m/%y
    [Return]    ${date}

Editing a Milestone
    Sleep    2 seconds
    Wait Until Page Contains Element    ${created_mile}
    Click Element    ${created_mile}
    Page Should Contain    ${milestone_name}
    Wait Until Page Contains Element    ${edit_mile_btn}
    Click Element    ${edit_mile_btn}
    Wait Until Element Is Visible    ${milestone_name_txt}
    Clear Element Text    ${milestone_name_txt}
    Input Text    ${milestone_name_txt}     ${updated_mile}
    Wait Until Element Is Visible   ${edit_mile_confirm_btn}
    Click Button    ${edit_mile_confirm_btn}
    Wait Until Element Is Visible   ${edit_mile_btn}
    Sleep    2 seconds
    Page Should Contain    Milestone Updated

Count Matching XPaths
    [Arguments]    ${xpath_expression}
    ${elements}    Get WebElements    xpath=${xpath_expression}
    [Return]    ${elements.__len__()}

Navigate to tab
    [Arguments]    ${project_name}  ${tab}
    Wait Until Page Contains Element    ${project_name}
    Click Element  ${project_name}
    Click Element   ${tab}

Create Test Suite
    ${api}=             Get Token Value         ${login_url}
	Create Session    my_session    ${base_url}
	${headers}=    Create Dictionary    Accept=*/*    Content-Type=application/x-www-form-urlencoded    charset=utf-8


	# POST request with data
	${data}=    Set Variable    UserName=saad.ahmed%4010pearls.com&Password=10PEarls1%2B&WebAddress=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
	${response}=    POST On Session        my_session    https://testworthy.us/Login/Login    headers=${headers}    data=${data}
	Should be equal as strings    ${response.status_code}    200
	Log To Console    Request: ${response.request.method} ${response.request.url}
	Log To Console    Response:${response.content}


	###################################################


	#Create Session    my_session1    ${base_url}
	${headers}=    Create Dictionary    Accept=*/*    Content-Type=application/x-www-form-urlencoded    charset=utf-8

    ${rand_data}=   Get Random String
	# POST request with data
	${data}=    Set Variable    Id=&ProjectId=${project_id}&Name=${test_suite}&Description=&__RequestVerificationToken=${api}&X-Requested-With=XMLHttpRequest
	${response}=    POST On Session        my_session    https://testworthy.us/TestSuite/Create   headers=${headers}    data=${data}
	Should be equal as strings    ${response.status_code}    200
	Log To Console    Request: ${response.request.method} ${response.request.url}
	Log To Console    Response:${response.content}

    ${json}=    Evaluate    json.loads('''${response.content}''')

    ${test_suite_id}=   Set Variable    ${json['result']['value']['result']['name']}
    Set Global Variable    ${test_suite_id}
    #Log To Console    mess:${error_message}
    Log To Console    id:${test_suite_id}
    [Return]    ${test_suite_id}

Open Testsuite
    Wait Until Page Contains Element    //span[@class='text']/a[text()='${test_suite_id}']
    Click Element    //span[@class='text']/a[text()='${test_suite_id}']

Edit Testsuite
    Wait Until Page Contains Element    ${edit_test_suite_btn}
    Click Element    ${edit_test_suite_btn}
    Wait Until Element Is Visible    ${edit_test_suite_txt}
    Clear Element Text      ${edit_test_suite_txt}
    Input Text    ${edit_test_suite_txt}    ${updated_test_suite}
    Wait Until Element Is Visible     ${save_edit_test_suite_btn}
    Click Element    ${save_edit_test_suite_btn}

Delete Testsuite
    Wait Until Page Contains Element    ${elipses_btn}
    Click Element    ${elipses_btn}
    Wait Until Page Contains Element    ${delete_test_suite_btn}
    Click Element    ${delete_test_suite_btn}
    Sleep    3 seconds
    #Wait Until Element Is Enabled        ${confirm_delete_suite_btn}
    Click Element    ${confirm_delete_suite_btn}
    #Wait Until Page Contains            xpath:(//span[text()='×'])[13]
    Sleep    3 seconds
    Click Element    xpath:(//span[text()='×'])[13]


Select Test Suite
    [Arguments]    ${test_suite}
    Wait Until Page Contains Element    ${test_suite}
    Click Element    ${test_suite}

Add Section
    Wait Until Page Contains Element    ${add_section_btn}
    Click Element    ${add_section_btn}
    Wait Until Element Is Visible         ${section_name_txt}   timeout=30s
    Input Text    ${section_name_txt}   ${section_name}
    Sleep    3 seconds
    #Wait Until Page Contains Element    ${add_section}      timeout=30s
    Click Element    ${add_section}
    Sleep    3 seconds
    #Wait Until Page Contains            xpath:(//span[text()='×'])[3]
    Click Element    ${sec_cnfrm_x}

Editing Section
    Sleep    3 seconds
    Wait Until Page Contains Element    ${section_label}
    Click Element    ${sec_edit_option}
    Wait Until Element Is Visible         ${section_name_txt}
    Input Text    ${section_name_txt}   ${updated_section_name}
    Sleep    3 seconds
    #Wait Until Page Contains    ${edit_sec_btn_save}    timeout=30s
    Click Element    ${edit_sec_btn_save}

Deleting Section
    Sleep    3 seconds
    Wait Until Page Contains Element    ${sec_delete_option}
    Click Element    ${sec_delete_option}
    Sleep    3 seconds
    Click Element   ${sec_delete}
    Sleep    3 seconds

Get Divs count
#    Wait Until Page Contains Element    xpath://div[@class='card parent']
#    ${count}=    Get Element Count      xpath://div[@class='card parent']
#    #Log To Console         ${count} elements found
#    RETURN  ${count}

    ${count}=   Get Text    id:spanSectionsCount
    RETURN  ${count}

Add Test Case
    Wait Until Page Contains Element    ${add_test_case_btn}
    Click Button    ${add_test_case_btn}
    Wait Until Page Contains    Add Test Case
    Input Text      ${add_test_case_title}    ${test_case_title}
    Select Frame    ${test_steps}
    Wait Until Page Contains Element    ${test_steps_body_txt}
    Input Text  ${test_steps_body_txt}    Your text goes here
    Unselect Frame
    Wait Until Page Contains Element    ${save_test_case_btn}   10 seconds
    Execute Javascript   document.getElementById("btnUpdateCase").click()

Save and next
    Wait Until Page Contains Element    ${add_test_case_btn}
    Click Button    ${add_test_case_btn}
    Wait Until Page Contains    Add Test Case
    Input Text      ${add_test_case_title}    ${test_case_title}
#    Select Frame    ${test_steps}
#    Wait Until Page Contains Element    ${test_steps_body_txt}
#    Input Text  ${test_steps_body_txt}    Your text goes here
#    Unselect Frame
    Wait Until Page Contains Element    ${save_next_test_case_btn}      7 seconds
    Execute Javascript   document.getElementById("btnUpdateCaseWithNext").click()

Preview Test Case
     Sleep    3 seconds
     Add Test Case
     Wait Until Page Contains Element    ${test_case_section}    10 seconds
     Click Element    ${test_case_section}
     Wait Until Page Contains Element    ${last_created_test_case}
     Click Element    ${last_created_test_case}
     Wait Until Page Contains    ${test_case_title}

Delete Test Case
    Add Test Case
    Wait Until Page Contains Element    ${test_case_section}    10 seconds
    Click Element    ${test_case_section}
    Wait Until Page Contains Element    ${last_created_test_case}
    Mouse Over    ${last_test_case_row}
    Wait Until Element Is Visible    ${test_case_delete_icon}
    Click Element    ${test_case_delete_icon}
    Wait Until Page Contains Element    ${del_tc_cnfrm_modal}     10 seconds
    Wait Until Element Is Visible   ${del_tc_cnfrm_btn}     10 seconds
    Click Button        ${del_tc_cnfrm_btn}

Get test count
    ${count}=   Get Text    id:spanCasesCount
    RETURN  ${count}

get counts
    [Arguments]    ${locator}
    ${count}=   Get Text    ${locator}
    [Return]    ${count}

Add Test Run
    Wait Until Page Contains Element    ${add_test_run_btn}
    Click Button    ${add_test_run_btn}
    Wait Until Page Contains Element    ${test_run_title_txt}
    Input Text    ${test_run_title_txt}     ${test_run_title}
    Wait Until Page Contains Element    ${test_suite_drpdown}
    Click Element    ${test_suite_drpdown}
    Wait Until Page Contains Element    ${test_suite_kfinanz}
    Click Element    ${test_suite_kfinanz}
    Wait Until Page Contains Element    ${test_selected_rdbtn}
    Click Element    ${test_selected_rdbtn}
    Wait Until Page Contains Element    ${select_cases_btn}
    Click Element    ${select_cases_btn}
    Wait Until Element Is Enabled        ${selected_folder}      10 seconds
    Execute JavaScript    document.evaluate("//span[@class='jstree-text' and normalize-space(text())='Inquiry Process']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click()
    Wait Until Element Is Enabled    ${select_test_case}     10 seconds
    Click Element    ${select_test_case}
    Wait Until Page Contains Element    ${select_case_cnfrm}    7 seconds
    Click Element    ${select_case_cnfrm}
    Wait Until Page Contains Element    ${selected_count_txt}

Milestone Reporting
    Wait Until Page Contains Element        ${mile_rep_gen_btn}
    Click Element    ${mile_rep_gen_btn}
    Wait Until Page Contains Element    ${report_name_txt}
    ${rep}=  Generate Random String
    ${rep1}=  Get Date(dmy)
    Input Text    ${report_name_txt}    ${rep} - ${rep1}
    Wait Until Page Contains Element    ${report_desc_txt}
    ${desc}=  Generate Random String
    Input Text    ${report_desc_txt}    ${desc}
    Wait Until Page Contains Element    ${select_mile_drp}
    Select From List By Label    ${select_mile_drp}     Staging
    Wait Until Page Contains Element    ${generate_rep_btn}     7 seconds
    #Click Button    ${generate_rep_btn}
    Execute Javascript   document.getElementById("milestoneReportBtn").click()

Import Test Cases
    Wait Until Page Contains Element    ${testing_suite}
    Click Element    ${testing_suite}
    Wait Until Page Contains Element    ${import_test_case_btn}
    Click Element    ${import_test_case_btn}
    Wait Until Page Contains Element    ${file_uplaod}      10 seconds
    Choose File     ${file_uplaod}     /home/saad/PycharmProjects/robot-cip/Cases_4_28_2023 7_38_57 AM.xlsx



