*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py

Resource    ../Resources/swag_login_resource.resource

*** Test Cases ***
Failed login
    [Documentation]    Verify error message is displayed with invalid credentials
    [Tags]             Regression
    Login   ${swag_user_invalid}    ${swag_password_invalid}
    Page Should Contain    Username and password do not match any user in this service

Locked user login
    [Documentation]    Verify error message is displayed when a locked user tries to login
    [Tags]             Regression
    Login   ${swag_user_locked}    ${swag_password}
    Page Should Contain    Sorry, this user has been locked out.




    //div[@class='inventory_list'] / div[@class='inventory_item']