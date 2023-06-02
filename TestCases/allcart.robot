*** Settings ***
Library    SeleniumLibrary
Library    ../Utils/randoms.py

Resource    ../Resources/swag_login_resource.resource


*** Test Cases ***

Sort Products by Name Descending Order
    Login    ${swag_user}   ${swag_password}
    Click Element    xpath://*[@class='product_sort_container']
    Click Element    xpath://select[@class='product_sort_container']/option[@value='za']    # Sort again to change the order to descending
    ${product_elements}    Get WebElements    xpath://div[@class='inventory_item_name']
    ${last_product}        Set Variable    ${EMPTY}
    FOR    ${product}    IN    @{product_elements}
        ${product_name}    Get Text    ${product}
        Set Global Variable     ${last_product}
        ${last_product}    Run Keyword If    '${product}' == '${product_elements[-1]}'     Set Variable    ${product_name}
    END
    Should Be True    '${last_product}' != '${EMPTY}'
    Log To Console    ${last_product}


Sort Products by Price in Ascending Order
    Login    ${swag_user}   ${swag_password}
    Click Element    ${sort_container}
    Click Element    ${prod_price_asc}    # Sort by price ascending order
    Sleep    3 seconds
    ${product_elements}    Get WebElements    ${prod_prices}
    ${last_product_price}    Set Variable    ${EMPTY}
    FOR    ${product}    IN    @{product_elements}
        ${product_price}    Get Text    ${product}
        Set Global Variable     ${last_product_price}
        ${last_product_price}   Run Keyword If    '${product}' == '${product_elements[-1]}'    Set Variable        ${product_price}
    END
    Should Be True    '${last_product_price}' != '${EMPTY}'
    Log To Console    ${last_product_price}


Sort Products by Price High to Low
    [Arguments]    ${sorter}
    Login    ${swag_user}   ${swag_password}
    Click Element    ${sort_container}
    Click Element    ${sorter}    # Sort by price descending order
    Sleep    3 seconds
    ${product_elements}    Get WebElements    ${prod_prices}
    ${last_product_price}    Set Variable    ${EMPTY}
    FOR    ${product}    IN    @{product_elements}
        ${product_price}    Get Text    ${product}
        Set Global Variable    ${last_product_price}
        ${last_product_price}   Run Keyword If    '${product}' == '${product_elements[-1]}'    Set Variable    ${product_price}
    END
    Should Be True    '${last_product_price}' != '${EMPTY}'
    Log To Console    ${last_product_price}