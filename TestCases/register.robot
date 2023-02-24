*** Settings ***
Library    SeleniumLibrary
Resource    ../Resources/register_resource.resource
Variables    ../TestData/TestData.py
Library    ../Utils/randoms.py

*** Variables ***

*** Test Cases ***
User should be able to open browser
    Open My Browser    ${URL}   ${browser}
    Page Should Contain    ${page_title}

User should be able to fill registeration form
    Enter First Name    ${first_name}
    Enter Last Name    ${last_name}
    ${first} =  emails
    Enter Email    ${first}
    Log To Console    ${first}
    Enter Password    ${password}
    Enter Confirm Password    ${confirm_password}

User should be able to click Register btn
    Click Register

    ${error_msg_element}=    Run Keyword And Return Status    Page Should Contain    The specified email already exists
    ${new}=  Emails
    Log To Console    error:${error_msg_element}

    IF        ${error_msg_element}==True
    Clear Element Text    ${txt_email}
    Input Text    ${txt_email}      ${new}
    Log To Console    new email: ${new}
    Sleep    3seconds
    Click Register

    ELSE IF    ${error_msg_element}==False
    Log To Console    Hello
    END
