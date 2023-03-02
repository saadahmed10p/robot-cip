*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py

Resource    ../Resources/register_resource.resource
Resource    ../Resources/shop_resource.resource

Variables    ../TestData/TestData.py
Variables    ../Utils/variables.py


*** Variables ***

*** Test Cases ***
User should be able to open browser
    Open My Browser    ${URL}   ${browser}
    Page Should Contain    ${page_title}

User should be able to fill registeration form
    Enter First Name    ${first_name}
    Enter Last Name    ${last_name}
    ${first} =  emails
    Set Global Variable    ${FIRST}     ${first}
    Enter Email    ${First}
    Log To Console    ${first}
    Enter Password    ${password}
    Enter Confirm Password    ${confirm_password}

User should be able to click Register btn
    Click Register

    ${error_msg_element}=    Run Keyword And Return Status    Page Should Contain    The specified email already exists
    Set Global Variable    ${ERROR_MSG_ELEMENT}    ${error_msg_element}
    ${new}=  Emails
    Set Global Variable    ${NEW}     ${new}
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

    #if condition to check username
    IF    ${ERROR_MSG_ELEMENT}==True
    Page Should Contain    ${NEW}
    ELSE IF    ${ERROR_MSG_ELEMENT}==False
    Page Should Contain    ${FIRST}
    END

User should be able to add products to cart
    Click Product 1
    Wait Until Element Is Visible        ${pdt1_addToCart}
    Add Product 1 To Cart

    #Check error msg appears
    Wait Until Page Contains    Enter valid recipient email
    Enter Recipient Name    ${receiver_name}
    Enter Recipient Email    ${receiver_email}
    ${full_name}=   Set Variable    ${first_name} ${last_name}

    #check sender name is prefilled
    ${sender}=  Get Sender Name
    Should Be Equal    ${sender}    ${full_name}
    Sleep    3 seconds



