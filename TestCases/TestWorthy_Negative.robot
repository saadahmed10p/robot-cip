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
# robot --test "Failed login" -v user:user2 -v env:prod TestCases/TestWorthy_Negative.robot

*** Test Cases ***
Failed login
    [Documentation]    Verify error message is displayed with invalid credentials
    [Tags]             Regression
    #Login      ${invalid_username}   ${valid_password}
    Login    ${user}    ${env}
    Wait Until Page Contains      ${msg}[1]   #${invalid_creds_msg}

    #robot --outputdir <output_directory> --output <output_html_file> --report <report_template_file> <test_suite_file>

    #robot --listener 'allure_robotframework;/home/saad/PycharmProjects/robot-cip/report' --test "Failed login" -v user:user2 -v env:prod TestCases/TestWorthy_Negative.robot
    #allure serve /home/saad/PycharmProjects/robot-cip/report

    #sudo chown -R $USER:$USER /home/saad/PycharmProjects