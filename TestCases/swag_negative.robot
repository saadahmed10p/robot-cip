*** Settings ***
Library    CSVLibrary
Library    SeleniumLibrary
Library    ../Utils/randoms.py
Library    OperatingSystem
Variables    ../TestData/Assertions.py

Resource    ../Resources/swag_login_resource.resource

*** Variables ***
${csv_file}    TestData/expected_errors.csv
${msg}    ${EMPTY}

*** Test Cases ***      assertions
Failed login
    [Documentation]    Verify error message is displayed with invalid credentials
    [Tags]             Regression
    Login   ${swag_user_invalid}    ${swag_password_invalid}
    Page Should Contain     ${invalid_creds_msg}    #Username and password do not match any user in this service


Locked user login
    [Documentation]    Verify error message is displayed when a locked user tries to login
    [Tags]             Regression
    Login   ${swag_user_locked}    ${swag_password}
    Page Should Contain    ${locked_user_msg}       #Sorry, this user has been locked out.

Checkout Page
    [Documentation]    User should not be able to move further without filling in contact details
    Login   ${swag_user}    ${swag_password}
    Click Function    ${add_to_cart_pdt1}
    ${count}=   Get Cart Badge
    Should Be Equal    ${count}    1
    Click Function    ${shopping_cart}
    Click Function    ${checkout_btn}
    Click Function    ${continue_btn}
    ${msg}=  Get Row Data   ${csv_file}
    Page Should Contain     ${msg}[0]
    Logout

#robot -d results -i Smoke TestCases/swag.robot
#robot --include=smoke TestCases/swag.robot
