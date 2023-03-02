*** Settings ***
Library     SeleniumLibrary
Variables   ../PageObjects/shop_locators.py

*** Keywords ***
Click Product 1
    Click Element    ${product1}

Add Product 1 To Cart
    Click Element    ${pdt1_addToCart}

Enter recipient name
    [Arguments]    ${receiver_name}
    Input Text    ${recipient_name}     ${receiver_name}

Enter recipient email
    [Arguments]    ${receiver_email}
    Input Text    ${recipient_email}    ${receiver_email}

Get sender name
    ${name}=  Get Value    ${sender_name}
    RETURN  ${name}