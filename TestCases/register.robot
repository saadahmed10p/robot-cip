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
    Page Should Contain    Register

User should be able to click Register action
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
    #Sleep    3seconds
    Click Register
    ELSE IF    ${error_msg_element}==False
    Log To Console    Hello
    END
    Page Should Contain    Your registration completed

User should be able to click continue after registering
    #Page Should Contain    Your registration completed
    Click Continue

    #if condition to check username
    IF    ${ERROR_MSG_ELEMENT}==True
    Page Should Contain    ${NEW}
    ELSE IF    ${ERROR_MSG_ELEMENT}==False
    Page Should Contain    ${FIRST}
    END

User should be able to click products form
    Click Product 1
    Wait Until Element Is Visible        ${pdt1_addToCart}
    Add Product 1 To Cart

User should not be able to move forward without entering name and email
    #Check error msg appears
    Wait Until Page Contains    Enter valid recipient email

User should be able to fill receipient form
    Enter Recipient Name    ${receiver_name}
    Enter Recipient Email    ${receiver_email}
    ${full_name}=   Set Variable    ${first_name} ${last_name}

    #check sender name is prefilled
    ${sender}=  Get Sender Name
    Should Be Equal    ${sender}    ${full_name}
    Sleep    3 seconds

User should be able to enter message for the product recipient
    Enter Text Function    ${message}   ${message_rec}

User should not be able to to enter invalid quantity
    Clear Field Funtion    ${qty_amount}
    Click Function  ${pdt1_addToCart}
    Wait Until Page Contains        Quantity should be positive
    Enter Text Function    ${qty_amount}    ${one_qty}

User shuould be able to perform add to cart action
    Click Function  ${pdt1_addToCart}
    Wait Until Page Contains    The product has been added to your
    ${main_page_qty}=  Get Shopping Qty
    Should Be Equal    ${main_page_qty}   (1)

User should be able to add products to wishlist
    Click Add To Wishlist
    Wait Until Page Contains    The product has been added to your

User should be able to proceed to shopping cart
    Click Function    ${shp_cart_link}
    Page Should Contain     Product(s)

User should be able to verify total amount
    ${total_amount}=    Calculate Total
    ${itm_pri}=  Get Item Price
    Should Be Equal    ${total_amount}  ${itm_pri}



