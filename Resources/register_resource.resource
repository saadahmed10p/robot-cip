*** Settings ***
Library     SeleniumLibrary
Variables   ../PageObjects/register_locators.py

*** Keywords ***
Open My Browser
    [Arguments]    ${URL}   ${Browser}
    Open Browser    ${URL}  ${Browser}
    Maximize Browser Window

Select Gender
    Click Element    ${radio_gender}

Enter First Name
    [Arguments]    ${firstname}
    Input Text    ${txt_firstname}  ${first_name}

Enter Last Name
    [Arguments]    ${lastname}
    Input Text    ${txt_lastname}   ${last_name}

Enter Email
    [Arguments]    ${email}
    Input Text    ${txt_email}   ${email}

Enter Password
    [Arguments]    ${password}
    Input Text    ${txt_password}   ${password}

Enter Confirm Password
    [Arguments]    ${confirmpassword}
    Input Text    ${txt_confirmpassword}   ${confirmpassword}

Click Register
    Click Element    ${btn_register}