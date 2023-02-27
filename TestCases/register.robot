*** Settings ***
Library    SeleniumLibrary
Resource    ../Resources/register_resource.resource
Variables    ../TestData/TestData.py
Variables    ../Utils/variables.py
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
    Set Global Variable    ${ERROR_MSG_ELEMENT}    ${error_msg_element}
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



User should be able to click continue after registering
    Page Should Contain    Your registration completed
    Click Continue
    Log To Console    loogiing:${ERROR_MSG_ELEMENT}
    Sleep    3seconds