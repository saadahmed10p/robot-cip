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

Click add to wishlist
    Click Element   ${add_wishlist}

Click function
    [Arguments]    ${elements}
    Click Element    ${elements}

Get shopping qty
    ${qty}=  Get Text     ${shp_cart_qty}
    RETURN  ${qty}

Get item price
    ${price}=  Get Text    ${item_price}
     ${price_num}=  Convert To Number   ${price}
    ${num}=  Convert To Integer    ${price_num}
    RETURN  ${num}

Get item qty
    ${item_qt}=  Get Value    ${item_qty}
    RETURN

Calculate total
    ${price}=  Get Text    ${item_price}
    Log To Console    priceis: ${price}

    ${price_num}=  Convert To Number   ${price}
    ${num}=  Convert To Integer    ${price_num}

    ${item_qt}=  Get Value    ${item_qty}
    ${item}=  Convert To Integer    ${item_qt}

    Log To Console    price is: ${num}
    ${total}=  Set Variable    ${${num} * ${item}}
    Log To Console        The total is: ${total}
    RETURN  ${total}

Enter text function
    [Arguments]    ${elements}  ${text}
    Input Text    ${elements}   ${text}

Clear field funtion
    [Arguments]    ${elements}
    Clear Element Text       ${elements}